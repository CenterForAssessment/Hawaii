#+ include = FALSE, purl = FALSE, eval = FALSE
######################################################################################
###                                                                                ###
###                Hawaii SGP analyses for 2022   .                                ###
###                                                                                ###
######################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/Hawaii_SGP.Rdata")
load("Data/Hawaii_Data_LONG_2022.Rdata")

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("HI", "2022")

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2022/PART_B/READING.R")
source("SGP_CONFIG/2022/PART_B/MATHEMATICS.R")

HI_CONFIG <- c(READING_2022.config, MATHEMATICS_2022.config)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

#####
###   Run updateSGP analysis
#####

Hawaii_SGP <- updateSGP(
        what_sgp_object = Hawaii_SGP,
        with_sgp_data_LONG = Hawaii_Data_LONG_2022,
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


###   Save results
save(Hawaii_SGP, file="Data/Hawaii_SGP.Rdata")

#' #### 2022 Analyses, Part B
#' 
#' In the second part of the 2022 analyses, we calculate "consecutive-year"
#' cohort- and baseline-referenced SGPs concurrently for grades 3 through 8
#' mathematics and ELA. Both SGP analysis versions use only a single prior
#' (i.e. 2021).
#' 
#' In the calculation workflow, we again first add the pre-calculated baseline
#' matrices to `SGPstateData` via the `SGPmatrices` package and load the 2022
#' configuration scripts to specify the analyses.
#'
#' In this part we use the [`updateSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.0-0.0/topics/updateSGP)
#' function to ***a)*** prepare the `Hawaii_SGP` object used in Part A and add
#' the cleaned and formatted 2022 data (`prepareSGP`), ***b)*** calculate 2022
#' consecutive-year cohort- and baseline-referenced SGP estimates and growth
#' projections (`analyzeSGP` step), ***c)*** merge the results into the master
#' longitudinal data set (`combineSGP` step), ***d)*** create summary tables
#' disaggregated at the state, district, complex and school levels
#' ([`summarizeSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.0-0.0/topics/updateSGP) step)
#' and ***e)*** save the results in both `.Rdata` and pipe delimited versions
#' ([`outputSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.0-0.0/topics/outputSGP) step).