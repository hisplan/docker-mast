#!/usr/bin/Rscript

# default repo
local({r <- getOption("repos")
    r["CRAN"] <- "https://cloud.r-project.org"
    options(repos=r)
})

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager", version="3.13")

# install dependency for MAST
BiocManager::install("data.table")

# install MAST
BiocManager::install("MAST")
