#!/bin/bash
#
# SPDX-FileCopyrightText: 2026 QuNex development team <https://qunex.yale.edu/>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Rebuild the CUDIMOT NODDI binaries in cuda_12/bin against an FSL install.
#
# The binaries link FSL's C++ libraries (libfsl-newimage and others), whose ABI
# changes between FSL releases, so they have to be rebuilt whenever the FSL they
# run with moves on. The source is the spmic-cudimot package FSL installs in
# $FSLDIR/src/spmic-cudimot. The toolchain is a conda environment with CUDA 12.2
# and gcc 12 on a glibc 2.17 sysroot, so the binaries need only glibc 2.14 and an
# NVIDIA driver; the CUDA runtime is linked statically.
#
# Only the binaries (and the .info and _priors files built with them) are
# replaced. The pipeline scripts next to them are maintained in this repository.
#
# usage: build_cudimot.sh [options]
#   --fsldir=<path>   FSL to build against (default: $FSLDIR)
#   --workdir=<path>  build directory (default: a new directory in /tmp)
#   --env=<path>      conda build environment, created when missing
#                     (default: <workdir>/cudaenv)
#   --outdir=<path>   where the binaries go (default: cuda_12/bin next to this script)
#   --models="<m>"    models to build (default: "NODDI_Watson NODDI_Bingham")
#   --jobs=<n>        parallel make jobs (default: 16)
#
# A full build of both models takes about an hour.

set -e

script_dir=$(cd "$(dirname "$0")" && pwd)
fsldir=${FSLDIR}
workdir=""
envdir=""
outdir=${script_dir}/cuda_12/bin
models="NODDI_Watson NODDI_Bingham"
jobs=16
cuda_version=12.2

usage() {
    sed -n '/^# usage:/,/^# A full build/p' "$0" | sed 's/^# \{0,1\}//'
}

error() {
    echo "ERROR: $1" >&2
    exit 1
}

for arg in "$@"; do
    case "$arg" in
        --fsldir=*) fsldir=${arg#*=} ;;
        --workdir=*) workdir=${arg#*=} ;;
        --env=*) envdir=${arg#*=} ;;
        --outdir=*) outdir=${arg#*=} ;;
        --models=*) models=${arg#*=} ;;
        --jobs=*) jobs=${arg#*=} ;;
        -h|--help) usage; exit 0 ;;
        *) error "unknown option $arg, see --help" ;;
    esac
done

# check inputs
[ -n "$fsldir" ] || error "FSLDIR is not set, set it or pass --fsldir"
src=$fsldir/src/spmic-cudimot
[ -f "$src/Makefile" ] || error "no cudimot source in $src, it comes with FSL's spmic-cudimot package"
[ -d "$outdir" ] || error "output folder $outdir does not exist"
micromamba_exe=$(command -v micromamba || echo "$fsldir/bin/micromamba")
[ -x "$micromamba_exe" ] || error "micromamba not found on PATH or in $fsldir/bin"

workdir=${workdir:-$(mktemp -d /tmp/cudimot_build.XXXXXX)}
mkdir -p "$workdir"
workdir=$(cd "$workdir" && pwd)
envdir=${envdir:-$workdir/cudaenv}
export MAMBA_ROOT_PREFIX=$workdir/mamba

echo "---> building $models against $(cat "$fsldir/etc/fslversion") in $workdir"

# build environment
if [ ! -x "$envdir/bin/nvcc" ]; then
    echo "---> creating the build environment in $envdir"
    "$micromamba_exe" create -y -p "$envdir" -c conda-forge --override-channels \
        cuda-nvcc=$cuda_version cuda-cudart-dev=$cuda_version \
        cuda-cudart-static=$cuda_version cuda-version=$cuda_version libcurand-dev \
        gxx_linux-64=12 sysroot_linux-64=2.17 make patchelf
fi

# activation sets CXX, CXXFLAGS, LDFLAGS and nvcc's host compiler (-ccbin)
eval "$("$micromamba_exe" shell hook -s bash)"
micromamba activate "$envdir"

export FSLDIR=$fsldir
export FSLCONFDIR=$fsldir/config
export FSLDEVDIR=$workdir/fsldev
export FSLOUTPUTTYPE=NIFTI_GZ
export CUDA=$envdir

# sources
rm -rf "${workdir:?}/src"
cp -r "$src" "$workdir/src"
cd "$workdir/src"

# link the CUDA runtime statically, so the binaries need only the driver
sed -i 's/-lcudart /-lcudart_static -ldl -lrt -lpthread /g' Makefile
# without ARMA_ALLOW_FAKE_GCC armadillo drops its alignment attributes under
# nvcc, arma::Mat then has a different layout in the .cu objects than in the FSL
# libraries and the fit crashes loading its parameters; FSL's own nvcc flags set it
sed -i 's/^NVCC_FLAGS = \(.*\)$/NVCC_FLAGS = \1 -DARMA_ALLOW_FAKE_GCC -std=c++17/' Makefile
grep -q "lcudart_static" Makefile && grep -q "ARMA_ALLOW_FAKE_GCC" Makefile ||
    error "the cudimot Makefile has changed, the build flags could not be set"

# every architecture CUDA 12.2 can build for; the separate device link keeps no PTX
gpu_cards=""
for sm in 50 52 60 61 70 72 75 80 86 89 90; do
    gpu_cards="$gpu_cards -gencode arch=compute_${sm},code=sm_${sm}"
done

# build every model before replacing anything, so a failure leaves outdir as it was
mkdir -p "$workdir/bin"
for model in $models; do
    [ -d "mymodels/$model" ] || error "no model $model in $src/mymodels"
    echo "---> building $model"
    rm -rf objs
    mkdir objs
    modelname=$model make -j"$jobs" all GPU_CARDs="$gpu_cards" NVCC="$envdir/bin/nvcc"
    for f in cart2spherical getFanningOrientation initialise_Psi \
        split_parts_$model $model merge_parts_$model $model.info ${model}_priors; do
        cp "objs/$f" "$workdir/bin/$f"
    done
done

# install, pointing the binaries at FSL's lib folder the way FSL installs them
# rather than at the build machine's FSL
echo "---> installing into $outdir"
for f in "$workdir"/bin/*; do
    if [ "$(head -c 4 "$f" | tail -c 3)" = "ELF" ]; then
        patchelf --set-rpath '$ORIGIN/../lib' "$f"
    fi
    cp "$f" "$outdir/"
done

echo "---> done, installed:"
ls -la "$workdir/bin"
echo "The build directory $workdir can be removed."
