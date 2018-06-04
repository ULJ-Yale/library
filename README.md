# README File for MNAP Library Utilities


Background
==========
---

This is a `library` component of the MNAP suite that contains miscellaneous dependencies.

The MNAP `library` are maintained by Alan Anticevic, [Anticevic Lab], Yale 
University of Ljubljana in collaboration with Grega Repovs [Mind and Brain Lab], 
University of Ljubljana.

Installation
===============================
---

### Step 1. Clone all MNAP repos and initiate submodules.

* Clone: `git clone git@bitbucket.org/hidradev/mnaptools.git` 
* Initiate submodules from inside cloned repo folder: `git submodule init`
* Pull and update all submodules: `git pull --recurse-submodules && git submodule update --recursive`
* Update submodules to latest commit on origin: `git submodule foreach git pull origin master`

### Step 2. Install all necessary dependencies for full functionality (see below). 

### Step 3. Configure `niutilities` repository. 

* Add `~/mnaptools/niutilities` folder to `$PATH`
* Add `~/mnaptools/niutilities` folder to `$PYTHONPATH`
* Make `~/mnaptools/niutilities/gmri` executable
* Install latest version of numpy, pydicom, scipy & nibabel
* (e.g. `pip install numpy pydicom scipy nibabel `)

### Step 4. Configure the environment script by adding the following lines to your .bash_profile.

	TOOLS=~/mnaptools
	export TOOLS
	source $TOOLS/library/environment/mnap_environment.sh
	

External dependencies
=====================
---
* All MNAP repositories for optimal functionality (git clone git@bitbucket.org:mnap/mnaptools.git)
* Connectome Workbench (v1.0 or above)
* FSL (version 5.0.6 or above with CUDA libraries)
* FreeSurfer (5.3 HCP version or later)
* MATLAB (version 2012b or above with Signal Processing, Statistics and Machine Learning and Image Processing Toolbox)
* FIX ICA
* PALM
* Python (version 2.7 or above)
* AFNI
* Human Connectome Pipelines modified for MNAP (https://bitbucket.org/mnap/hcpmodified)
* Gradunwarp for HCP workflow (https://github.com/ksubramz/gradunwarp)
* R Statistical Environment


Usage and command documentation
===============================
---

For overall usage of the MNAP suite refer to the README in the master `mnaptools` repository. 


References
==========
---

Yang GJ, Murray JD, Repovs G, Cole MW, Savic A, Glasser MF, Pittenger C,
Krystal JH, Wang XJ, Pearlson GD, Glahn DC, Anticevic A. Altered global brain
signal in schizophrenia. Proc Natl Acad Sci U S A. 2014 May 20;111(20):7438-43.
doi: 10.1073/pnas.1405289111. PubMed PMID: 24799682; PubMed Central PMCID:
PMC4034208.


[Mind and Brain Lab]: http://mblab.si
[Anticevic Lab]: http://anticeviclab.yale.edu
