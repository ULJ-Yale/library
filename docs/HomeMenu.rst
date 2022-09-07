Background
----------

The **Qu**\ antitative **N**\ euroimaging **E**\ nvironment &
Toolbo\ **x** (`QuNex <https://qunex.yale.edu>`__) integrates several
packages that support a flexible and extensible framework for data
organization, preprocessing, quality assurance, and various analyses
across neuroimaging modalities. The QuNex suite is flexible and can be
updated by adding specific functions and units of code to support new
command calls developed around its component tools.

QuNex suite is developed and maintained by the:

-  `Anticevic Lab, Yale University <http://anticeviclab.yale.edu/>`__,
-  `Mind and Brain Lab, University of Ljubljana <https://mblab.si/>`__,
-  `Murray Lab, Yale
   University <https://medicine.yale.edu/lab/murray/>`__.

--------------

Registration
------------

QuNex is free and open source, to get access to it visit `Official QuNex
Registration page <https://qunex.yale.edu/qunex-registration/>`__.

--------------

Forum and issue reporting
-------------------------

You can find our official QuNex forum at https://forum.qunex.yale.edu/.
Feel free to open up a discussion about anything QuNex related there.
The forum is also the official QuNex issue reporting platform. If you
are struggling with running a command and cannot find the help in the
documentation open a post on the forum. To maintain an effective issue
resolving workflow and make sure your problems will be solved in a
timely manner we prepared `simple
guide <https://forum.qunex.yale.edu/t/qu-nex-issue-reporting-guide-the-dcl-protocol/27>`__.

--------------

`QuNex quick start <wiki/Overview/QuickStart.html>`__
-----------------------------------------------------

Quick start on deploying the QuNex suite starting from raw data to
launching HCP pipelines.

--------------

`General overview <wiki/Overview/Overview.html>`__
--------------------------------------------------

QuNex overview describes general functionality and specifications.

-  `Installing from source and dependencies <wiki/Overview/Installation.html>`__

-  `QuNex container deployment <wiki/Overview/QuNexContainerUsage.html>`__

-  `QuNex commands and general usage overview <wiki/Overview/GeneralUse.html>`__

-  `File formats overview <wiki/Overview/FileFormats.html>`__

-  `QuNex data hierarchy specification <wiki/Overview/DataHierarchy.html>`__

-  `Logging and log files <wiki/Overview/Logging.html>`__

-  `Visual schematic of QuNex steps <wiki/Overview/VisualSchematic.html>`__

-  `BIDS support within QuNex <wiki/Overview/QuNexBIDS.html>`__

-  `How to report issues with QuNex <wiki/Overview/QuNexIssues.html>`__

--------------

`User guides <wiki/UsageDocs/Overview.html>`__
----------------------------------------------

User guides provides in-depth description of QuNex usage, detailing
specific functions, workflows and use cases.

Executing QuNex commands
~~~~~~~~~~~~~~~~~~~~~~~~

-  `Running commands against a container using
   qunex_container <wiki/UsageDocs/RunningQunexContainer.html>`__

-  `QuNex ‘turnkey’ workflow and ‘batch’ engine <wiki/UsageDocs/Turnkey.html>`__

-  `Running lists of QuNex
   commands <wiki/UsageDocs/RunningListsOfCommands.html>`__

-  `Running commands over multiple
   sessions <wiki/UsageDocs/RunningMultipleSessions.html>`__

-  `Parallel Execution and Scheduling of QuNex
   commands <wiki/UsageDocs/Scheduling.html>`__

Onboarding data into QuNex
~~~~~~~~~~~~~~~~~~~~~~~~~~

-  `De-identifying DICOM files <wiki/UsageDocs/DICOMDeidentification.html>`__

-  `Preparing the QuNex study folder
   hierarchy <wiki/UsageDocs/PreparingStudy.html>`__

-  `Onboarding new data into QuNex <wiki/UsageDocs/OnboardingNewData.html>`__

Preparing mapping and batch files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  `Preparing a study-level mapping file for QuNex
   workflows <wiki/UsageDocs/PreparingMappingFile.html>`__

-  `Preparing study-level batch file and parameters for QuNex
   workflows <wiki/UsageDocs/GeneratingBatchFiles.html>`__

Running HCP pipelines and performing QC
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  `Preparing and running the HCP
   pipeline <wiki/UsageDocs/HCPPreprocessing.html>`__

-  `Running quality control (QC) across
   modalities <wiki/UsageDocs/MultiModalQC.html>`__

BOLD preprocessing & analyses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  `BOLD task-evoked and resting-state functional connectivity
   preprocessing <wiki/UsageDocs/BOLDPreprocessing.html>`__

-  `BOLD movement scrubbing <wiki/UsageDocs/MovementScrubbing.html>`__

-  `Running 1st and 2nd level BOLD task activation
   analyses <wiki/UsageDocs/BOLDTaskActivation.html>`__

-  `Running BOLD functional connectivity
   analyses <wiki/UsageDocs/BOLDFunctionalConnectivity.html>`__

-  `Group-level statistics and mapping of
   results <wiki/UsageDocs/GroupLevelStats.html>`__

-  `Identifying empirical ROI and extracting peak
   information <wiki/UsageDocs/ROIanalyses.html>`__

DWI preprocessing & analyses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  `Diffusion weighted imaging (DWI) ‘legacy’ data
   preprocessing <wiki/UsageDocs/DWILegacyPreprocessing.html>`__

-  `Running DWI analyses <wiki/UsageDocs/DWIAnalyses.html>`__

Data visualization & output mapping
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  `Visualizing data via CIFTI
   templates <wiki/UsageDocs/CIFTIVisualizationTemplate.html>`__

-  `Mapping processed data in and out of
   QuNex <wiki/UsageDocs/MappingDataInAndOutQuNex.html>`__

Non human primate (NHP) pipelines
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  `Post-mortem macaque tractography <wiki/UsageDocs/PostMortemMacaque.html>`__

--------------

QuNex deployment in XNAT
------------------------

Overview of interacting with the XNAT environment and executing QuNex
container using the XNAT container service.

-  `QuNex-XNAT introduction and container setup <wiki/XNAT/QuNex_XNAT.html>`__

-  `Launching the QuNex container in
   XNAT <wiki/XNAT/XNAT_container_launch.html>`__

-  `XNAT management for advanced users and
   administrators <wiki/XNAT/XNAT_management.html>`__

--------------

QuNex development
-----------------

To support development of QuNex, we have prepared `QuNex
SDK <https://gitlab.qunex.yale.edu/qunexdev/qunexsdk>`__, a separate set
of tools provided as a Git repository created to support the development
and acceptance testing procedures for core QuNex developers as well as
others who wish to contribute to the QuNex codebase.

For documentation related to development, please use the `QuNex SDK
Wiki <https://gitlab.qunex.yale.edu/qunexdev/qunexsdk/-/wikis/home>`__.
