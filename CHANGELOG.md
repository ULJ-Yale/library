# qx_library change log

* 0.90.0  Code restructuring for public release candidate.
* 0.62.4  Update the qunex_container documentation so the use of CUDA flag (--nv) is now clearer.
* 0.62.3  Removed the latest suffix from the QuNex folder structure.
* 0.62.2  Cleaned up code that used deprecated CUDA versions.
* 0.62.1  SLURM scheduling in qunex_container now supports flags (parameters without values).
* 0.62.0  Documentation rework.
* 0.61.7  Added CUDA 9.1 bedpostx support.
* 0.61.6  Made qunex_container parameter passing more robust.
* 0.61.5  Added --nv flag to Singularity runs in qunex_container for CUDA support.
* 0.61.4  When running through Singularity CUDA is not loaded from inside the container.
* 0.61.3  qunex_envstatus now prints out HCPpipelines TAG and commit hash.
* 0.61.2  Added CUDA to PATH.
* 0.61.1  Added SpecFolder attribute to the qunex_container.sh script.
* 0.61.0  Implementation of bug fixes across bash qx_utilities and pipeline restructure back-compatibility
* 0.60.1  Full support for hcp_suffix in run_qc.
* 0.60.0  Renamed all subject related parameters to session. Pipeline architecture restructure.
* 0.50.11 Updated cole_anticevic_net_partition with files from most recent release (v1.1.4) of the parcellation.
* 0.50.10 Updated cole_anticevic_net_partition with files from most recent release of the parcellation.
* 0.50.9  Added montage templates to the repository.
* 0.50.8  Consistent jobname in scheduling between qunex and qunex_container.
* 0.50.7  License and README updates.
* 0.50.6  Replaced REMOVED.git-id files.
* 0.50.5  Fixed QC templates.
* 0.50.4  Renamed cores and threads parameters.
* 0.50.3  Set MSMSulc as the default regname.
* 0.50.2  qunex_envstatus now reports OS info.
* 0.50.1  Removed double slash in derivates from MATLABDIR.
* 0.50.0  Renamed gmrimage class to nimage and methods names from mri\_ to img\_.
* 0.49.11 Environemnt changes for HCP ICAFix.
* 0.49.10 Initial submodule versioning.