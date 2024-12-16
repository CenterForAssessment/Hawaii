#+ include = FALSE, purl = FALSE, eval = FALSE
######################################################################################
###                                                                                ###
###                Hawaii SGP analyses for 2024                                    ###
###                                                                                ###
######################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/Hawaii_SGP.Rdata")
load("Data/Hawaii_Data_LONG_2024.Rdata")

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("HI", "2024")

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2024/READING.R")
source("SGP_CONFIG/2024/MATHEMATICS.R")

HI_CONFIG <- c(READING_2024.config, MATHEMATICS_2024.config)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

#####
###   Run updateSGP analysis
#####

Hawaii_SGP <- updateSGP(
        what_sgp_object = Hawaii_SGP,
        with_sgp_data_LONG = Hawaii_Data_LONG_2024,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "summarizeSGP", "outputSGP"),
        sgp.config = HI_CONFIG,
        sgp.percentiles = TRUE,
        sgp.projections = TRUE,
        sgp.projections.lagged = TRUE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = TRUE,
        sgp.projections.lagged.baseline = TRUE,
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
)


###   Add R session info & save results (`cfaDocs` version 0.0-1.12 or later)
source(
    system.file(
        "rmarkdown", "shared_resources", "rmd", "R_Session_Info.R",
        package = "cfaDocs"
    )
)
Hawaii_SGP@Version$session_platform <- list("2024" = session_platform)
Hawaii_SGP@Version$attached_pkgs    <- list("2024" = attached_pkgs)
Hawaii_SGP@Version$namespace_pkgs   <- list("2024" = namespace_pkgs)


###   Save results
save(Hawaii_SGP, file="Data/Hawaii_SGP.Rdata")


#' ### Conduct SGP analyses
#'
#' All data analysis is conducted using the [`R` Software Environment](http://www.r-project.org/)
#' in conjunction with the [`SGP` package](http://sgp.io/). Cohort- and
#' baseline-referenced SGPs were calculated concurrently for the 2024 Hawai'i
#' SBA growth model analyses following these five steps:
#'
#' 1. `prepareSGP`
#' 2. `analyzeSGP`
#' 3. `combineSGP`
#' 4. `summarizeSGP`
#' 5. `outputSGP`
#'
#' Because these steps are almost always conducted simultaneously, the `SGP`
#' package has "wrapper" functions, `abcSGP` and `updateSGP`, that combine
#' the above steps into a single function call and simplify the source code
#' associated with the data analysis. Documentation for all SGP functions are
#' [available online.](https://cran.r-project.org/web/packages/SGP/SGP.pdf)
#'
#' #### 2024 Growth Analyses
#'
#' "Consecutive-year" growth percentiles were calculated for grades 4 through 8
#' ELA and mathematics. Both cohort and baseline referenced growth model versions
#' use up to two prior years' scores (i.e. 2022 and 2023) where available.
#'
#' In the calculation workflow, we first add pre-calculated baseline matrices
#' to the Hawai'i entry in the `SGPstateData` object using the `addBaselineMatrices`
#' function from the `SGPmatrices` package (which also serves as a repository for
#' the baseline matrices). The 2024 configuration scripts were loaded and combined
#' into a single list object that serves to specify the exact analyses to be run.
#'
#' We use the [`updateSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.0-0.0/topics/updateSGP)
#' function to ***a)*** prepare the `Hawaii_SGP` object saved from the 2023 growth
#' analyses and add the cleaned and formatted 2024 data (`prepareSGP`), ***b)*** 
#' calculate consecutive-year cohort- and baseline-referenced SGP estimates and
#' growth projections, ***c)*** merge the results into the master longitudinal
#' data set ([`combineSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.0-0.0/topics/combineSGP)
#' step), ***d)*** create summary tables disaggregated at the state, district,
#' complex and school levels ([`summarizeSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.0-0.0/topics/summarizeSGP)
#' step) and ***e)*** save the results in both `.Rdata` and pipe delimited versions
#' ([`outputSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.0-0.0/topics/outputSGP)
#' step).
