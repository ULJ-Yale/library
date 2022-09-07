:og:description: The Quantitative Neuroimaging Environment & Toolbox (QuNex) integrates several packages that support a flexible and extensible framework for data organization, preprocessing, quality assurance, and various analyses across neuroimaging modalities. 
 
.. image:: wiki/Images/QuNex_Logo_pantheonsite.png 
   :align: center
 
-------------- 
 
.. toctree:: 
   :maxdepth: 2 
   :hidden: 
 
   QuNex quick start <wiki/Overview/QuickStart.md> 

.. toctree:: 
   :maxdepth: 2 
   :caption: General overview 
   :hidden:
 
   Overview <wiki/Overview/Overview.md> 
   Installing from source and dependencies <wiki/Overview/Installation> 
   QuNex container deployment <wiki/Overview/QuNexContainerUsage> 
   QuNex commands and general usage overview <wiki/Overview/GeneralUse> 
   File formats overview <wiki/Overview/FileFormats> 
   QuNex data hierarchy specification <wiki/Overview/DataHierarchy> 
   Logging and log files <wiki/Overview/Logging> 
   Visual schematic of QuNex steps <wiki/Overview/VisualSchematic> 
   BIDS support within QuNex <wiki/Overview/QuNexBIDS> 
   How to report issues with QuNex <wiki/Overview/QuNexIssues> 

.. toctree:: 
   :maxdepth: 2 
   :caption: User guides 
   :hidden:
 
   Overview <wiki/UsageDocs/Overview.md> 
   Running commands against a container using qunex_container <wiki/UsageDocs/RunningQunexContainer> 
   QuNex 'turnkey' workflow and 'batch' engine <wiki/UsageDocs/Turnkey> 
   Running lists of QuNex commands <wiki/UsageDocs/RunningListsOfCommands> 
   Running commands over multiple sessions <wiki/UsageDocs/RunningMultipleSessions> 
   Parallel Execution and Scheduling of QuNex commands <wiki/UsageDocs/Scheduling> 
   De-identifying DICOM files <wiki/UsageDocs/DICOMDeidentification> 
   Preparing the QuNex study folder hierarchy <wiki/UsageDocs/PreparingStudy> 
   Onboarding new data into QuNex <wiki/UsageDocs/OnboardingNewData> 
   Preparing a study-level mapping file for QuNex workflows <wiki/UsageDocs/PreparingMappingFile> 
   Preparing study-level batch file and parameters for QuNex workflows <wiki/UsageDocs/GeneratingBatchFiles> 
   Preparing and running the HCP pipeline <wiki/UsageDocs/HCPPreprocessing> 
   Running quality control (QC) across modalities <wiki/UsageDocs/MultiModalQC> 
   BOLD task-evoked and resting-state functional connectivity preprocessing <wiki/UsageDocs/BOLDPreprocessing> 
   BOLD movement scrubbing <wiki/UsageDocs/MovementScrubbing> 
   Running 1st and 2nd level BOLD task activation analyses <wiki/UsageDocs/BOLDTaskActivation> 
   Running BOLD functional connectivity analyses <wiki/UsageDocs/BOLDFunctionalConnectivity> 
   Group-level statistics and mapping of results <wiki/UsageDocs/GroupLevelStats> 
   Identifying empirical ROI and extracting peak information <wiki/UsageDocs/ROIanalyses> 
   Diffusion weighted imaging (DWI) 'legacy' data preprocessing <wiki/UsageDocs/DWILegacyPreprocessing> 
   Running DWI analyses <wiki/UsageDocs/DWIAnalyses> 
   Visualizing data via CIFTI templates <wiki/UsageDocs/CIFTIVisualizationTemplate> 
   Mapping processed data in and out of QuNex <wiki/UsageDocs/MappingDataInAndOutQuNex> 
   Post-mortem macaque tractography <wiki/UsageDocs/PostMortemMacaque> 

.. toctree:: 
   :maxdepth: 2 
   :caption: QuNex deployment in XNAT 
   :hidden:
 
   QuNex-XNAT introduction and container setup <wiki/XNAT/QuNex_XNAT> 
   Launching the QuNex container in XNAT <wiki/XNAT/XNAT_container_launch> 
   XNAT management for advanced users and administrators <wiki/XNAT/XNAT_management> 

.. toctree:: 
   :maxdepth: 3 
   :caption: Specific command documentation 
   :hidden:
 
   api/gmri 

.. include:: HomeMenu.rst
 
