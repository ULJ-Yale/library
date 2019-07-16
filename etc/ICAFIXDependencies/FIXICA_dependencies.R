# https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FIX/UserGuide --> Check for correct dependencies

.libloc <<- "~/R_libs/"
assign(".lib.loc", "~/R_libs/", envir = environment(.libPaths))

# -- Function to check whether package is installed
is.installed <- function(mypkg){
  is.element(mypkg, installed.packages()[,1])
} 

# -- R dependencies --> Install these packages for R to run in fix
if (!is.installed("devtools")){
  install.packages("devtools", repos="https://cloud.r-project.org", dependencies=TRUE, lib="~/R_libs/")
}

# -- Dependencies and install for party
if (!is.installed("mvtnorm")){
  install.packages('mvtnorm', repos="https://cloud.r-project.org", dependencies=TRUE, lib="~/R_libs/")
}
if (!is.installed("modeltools")){
  install.packages('modeltools', repos="https://cloud.r-project.org", dependencies=TRUE, lib="~/R_libs/")
}
if (!is.installed("strucchange")){
   install.packages('strucchange', repos="https://cloud.r-project.org", dependencies=TRUE, lib="~/R_libs/")
}
if (!is.installed("coin")){
  install.packages('coin', repos="https://cloud.r-project.org", dependencies=TRUE, lib="~/R_libs/")
}
if (!is.installed("zoo")){
  install.packages('zoo', repos="https://cloud.r-project.org", dependencies=TRUE, lib="~/R_libs/")
}
if (!is.installed("sandwich")){
  install.packages('sandwich', repos="https://cloud.r-project.org", dependencies=TRUE, lib="~/R_libs/")
}
if (!is.installed("lattice")){
  install.packages('lattice', repos="https://cloud.r-project.org", dependencies=TRUE, lib="~/R_libs/")
}
if (!is.installed("Matrix")){
  install.packages('Matrix', repos="https://cloud.r-project.org", dependencies=TRUE, lib="~/R_libs/")
}
if (!is.installed("codetools")){
  install.packages('codetools', repos="https://cloud.r-project.org", dependencies=TRUE, lib="~/R_libs/")
}
if (!is.installed("MASS")){
  install.packages('MASS', repos="https://cloud.r-project.org", dependencies=TRUE, lib="~/R_libs/")
}
# -- Dependencies and install for party
if (is.installed("party")){
  CheckVersionParty <- packageVersion("party")=="1.0-25"
} else {
CheckVersionParty <- "FALSE"
}
if (CheckVersionParty!="TRUE"){
  if (is.installed("party")){
    remove.packages("party")
  }
  packageurl <- "https://cran.r-project.org/src/contrib/Archive/party/party_1.0-25.tar.gz"
  install.packages(packageurl, repos=NULL, type="source", dependencies=TRUE, lib="~/R_libs/")
  packageVersion('party')
}

# -- Dependencies and install for kernlab
if (is.installed("kernlab")){
  CheckVersionkernlab <- packageVersion("kernlab")=="0.9-24"
} else {
CheckVersionkernlab <- "FALSE"
}
if (CheckVersionkernlab!="TRUE"){
  if (is.installed("kernlab")){
    remove.packages("kernlab")
  }
  packageurl <- "https://cran.r-project.org/src/contrib/Archive/kernlab/kernlab_0.9-24.tar.gz"
  install.packages(packageurl, type="source", dependencies=TRUE, lib="~/R_libs/")
  packageVersion('kernlab')
}

# -- Dependencies and install for ROCR
#packageurl <- "https://cran.r-project.org/src/contrib/ROCR_1.0-7.tar.gz"
if (is.installed("ROCR")){
  CheckVersionROCR <- packageVersion("ROCR")=="1.0-7"
} else {
CheckVersionROCR <- "FALSE"
}
if (CheckVersionROCR!="TRUE"){
  if (is.installed("ROCR")){
    remove.packages("ROCR")
  }
  install.packages('ROCR', type="source", dependencies=TRUE, repos="https://cloud.r-project.org", lib="~/R_libs/")
  packageVersion('ROCR')
}

# -- Dependencies and install for class
# packageurl <- "https://cran.r-project.org/src/contrib/class_7.3-14.tar.gz"
if (is.installed("class")){
  CheckVersionclass <- packageVersion("class")=="7.3-14"
} else {
CheckVersionclass <- "FALSE"
}
if (CheckVersionclass!="TRUE"){
  if (is.installed("class")){
    remove.packages("class")
  }
  install.packages('class', type="source", repos="https://cloud.r-project.org", lib="~/R_libs/")
  packageVersion('class')
}

# -- Dependencies and install for e1071
if (is.installed("e1071")){
  CheckVersione1071 <- packageVersion("e1071")=="1.6-7"
} else {
CheckVersione1071 <- "FALSE"
}
if (CheckVersione1071!="TRUE"){
  if (is.installed("e1071")){
    remove.packages("e1071")
  }
  packageurl <- "https://cran.r-project.org/src/contrib/Archive/e1071/e1071_1.6-7.tar.gz"
  install.packages(packageurl, type="source", dependencies=TRUE, lib="~/R_libs/")
  packageVersion('e1071')
}

# -- Dependencies and install for randomForest
if (is.installed("randomForest")){
  CheckVersionrandomForest <- packageVersion("randomForest")=="4.6-12"
} else {
CheckVersionrandomForest <- "FALSE"
}
if (CheckVersionrandomForest!="TRUE"){
  if (is.installed("randomForest")){
    remove.packages("randomForest")
  }
  packageurl <- "https://cran.r-project.org/src/contrib/Archive/randomForest/randomForest_4.6-12.tar.gz"
  install.packages(packageurl, type="source", dependencies=TRUE, lib="~/R_libs/")
  packageVersion('randomForest')
}

message ("")
message ("Final installed versions:")
message ("---------------------------")
message ("")
message ("Package: party")
packageVersion('party')
message (".......")
message ("Package: kernlab")
packageVersion('kernlab')
message (".......")
message ("Package: ROCR")
packageVersion('ROCR')
message (".......")
message ("Package: class")
packageVersion('class')
message (".......")
message ("Package: e1071")
packageVersion('e1071')
message (".......")
message ("Package: randomForest")
packageVersion('randomForest')
message ("")
message ("---------------------------")

