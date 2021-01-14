# README File for QuNex Library Component

The QuNex `library` component contains miscellaneous dependencies, 
environment scripts, relevant data, parameter files, etc. The `library` code 
is required for proper QuNex functionality.

The QuNex `library` code is co-developed and co-maintained by the:

* [Anticevic Lab, Yale University](http://anticeviclab.yale.edu/),
* [Mind and Brain Lab, University of Ljubljana](http://psy.ff.uni-lj.si/mblab/en),
* [Murray Lab, Yale University](https://medicine.yale.edu/lab/murray/).


Quick links
-----------

* [Website](http://qunex.yale.edu/)
* [QuNex Wiki](https://bitbucket.org/oriadev/qunex/wiki/Home)
* [SDK Wiki](https://bitbucket.org/oriadev/qunexsdk/wiki/Home)
* [QuNex quick start](https://bitbucket.org/oriadev/qunex/wiki/Overview/QuickStart.md)
* [QuNex container deployment](https://bitbucket.org/oriadev/qunex/wiki/Overview/Installation.md)
* [Installing from source and dependencies](https://bitbucket.org/oriadev/qunex/wiki/Overview/Installation.md)


Change log
----------

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
* 0.60.1  Full support for hcp_suffix in runQC.
* 0.60.0  Renamed all subject related parameters to session. Pipeline architecture restructure.
* 0.50.11 Updated ColeAnticevicNetPartition with files from most recent release (v1.1.4) of the parcellation.
* 0.50.10 Updated ColeAnticevicNetPartition with files from most recent release of the parcellation.
* 0.50.9  Added montage templates to the repository.
* 0.50.8  Consistent jobname in scheduling between qunex and qunex_container.
* 0.50.7  License and README updates.
* 0.50.6  Replaced REMOVED.git-id files.
* 0.50.5  Fixed QC templates.
* 0.50.4  Renamed cores and threads parameters.
* 0.50.3  Set MSMSulc as the default regname.
* 0.50.2  qunex_envstatus now reports OS info.
* 0.50.1  Removed double slash in derivates from MATLABDIR.
* 0.50.0  Renamed gmrimage class to nimage and methods names from mri_ to img_.
* 0.49.11 Environemnt changes for HCP ICAFix.
* 0.49.10 Initial submodule versioning.


References
----------

Yang GJ, Murray JD, Repovs G, Cole MW, Savic A, Glasser MF, Pittenger C,
Krystal JH, Wang XJ, Pearlson GD, Glahn DC, Anticevic A. Altered global brain
signal in schizophrenia. Proc Natl Acad Sci U S A. 2014 May 20;111(20):7438-43.
doi: 10.1073/pnas.1405289111. PubMed PMID: 24799682; PubMed Central PMCID:
PMC4034208.
