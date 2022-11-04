#+ include = FALSE, purl = FALSE, eval = FALSE
#########################################################################################
###                                                                                   ###
###          Hawaii 2019 consecutive-year BASELINE SGP analyses                       ###
###          NOTE: Doing this in 2022 thus the file name                              ###
###                                                                                   ###
#########################################################################################

###   Load packages
require(SGP)
require(data.table)
require(SGPmatrices)

###   Load data
load("Data/Hawaii_SGP.Rdata")

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("HI", "2021")
SGPstateData[["HI"]][["Assessment_Program_Information"]][["CSEM"]] <- NULL

###   Rename the skip-year SGP variables and objects

##    We can simply rename the BASELINE variables. We only have 2019/21 skip yr
# table(Hawaii_SGP@Data[!is.na(SGP_BASELINE),
#         .(CONTENT_AREA, YEAR), GRADE], exclude = NULL)
baseline.names <- grep("BASELINE", names(Hawaii_SGP@Data), value = TRUE)
setnames(Hawaii_SGP@Data,
         baseline.names,
         paste0(baseline.names, "_SKIP_YEAR"))

sgps.2019 <- grep(".2019.BASELINE", names(Hawaii_SGP@SGP[["SGPercentiles"]]))
names(Hawaii_SGP@SGP[["SGPercentiles"]])[sgps.2019] <-
    gsub(".2019.BASELINE",
         ".2019.SKIP_YEAR_BLINE",
         names(Hawaii_SGP@SGP[["SGPercentiles"]])[sgps.2019])


###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2022/PART_A/READING.R")
source("SGP_CONFIG/2022/PART_A/MATHEMATICS.R")

HI_Baseline_Config_2019 <- c(
  READING.2019.config,
  MATHEMATICS.2019.config
)

###   Parallel Config
parallel.config <- list(BACKEND = "PARALLEL",
                        WORKERS = list(BASELINE_PERCENTILES = 8))


#####
###   Run abcSGP analysis
#####

Hawaii_SGP <-
    abcSGP(sgp_object = Hawaii_SGP,
           years = "2019",
           steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
           sgp.config = HI_Baseline_Config_2019,
           sgp.percentiles = FALSE,
           sgp.projections = FALSE,
           sgp.projections.lagged = FALSE,
           sgp.percentiles.baseline = TRUE,
           sgp.projections.baseline = FALSE,
           sgp.projections.lagged.baseline = FALSE,
           simulate.sgps = FALSE,
           parallel.config = parallel.config)

###   Save results
save(Hawaii_SGP, file = "Data/Hawaii_SGP.Rdata")


#' ### Conduct SGP analyses
#' 
#' All data analysis is conducted using the [`R` Software Environment](http://www.r-project.org/)
#' in conjunction with the [`SGP` package](http://sgp.io/). Cohort- and
#' baseline-referenced SGPs were calculated in two parts for the 2022 Hawai'i
#' SBA growth model analyses. Each part of the 2022 analyses were completed in
#' these 5 steps:
#'
#' 1. `prepareSGP`
#' 2. `analyzeSGP`
#' 3. `combineSGP`
#' 4. `summarizeSGP`
#' 5. `outputSGP`
#' 
#' Because these steps are almost always conducted simultaneously, the `SGP`
#' package has wrapper functions, `abcSGP` and `updateSGP`, that combine the
#' above steps into a single function call and simplify the source code
#' associated with the data analysis. Documentation for all SGP functions are
#' [available online.](https://cran.r-project.org/web/packages/SGP/SGP.pdf)
#' 
#' #### 2022 Analyses, Part A
#' 
#' In the first part of the 2022 analyses, we first calculated "consecutive-year"
#' baseline-referenced SGPs for grades 4 through 8 in both mathematics and
#' ELA^[11<sup>th</sup> grade analyses require a two-year skip grade progression and were therefore were excluded from consecutive-year analyses.].
#' These baseline SGP analyses use up to three consecutive years of data (i.e. 2018
#' and 2017 as priors and 2019 as the current year), meaning they are roughly
#' analogous to the original 2019 cohort-referenced analyses. These analyses are
#' necessary to provide a direct comparison with the 2022 baseline-referenced
#' results.
#' 
#' These analyses also differ from the 2019 baseline-referenced growth analyses
#' conducted in 2021, which were skip-year analyses (i.e. 2017 and 2016, when
#' available, used as priors with 2019 as the current year) used to compare with
#' the 2021 skip-year SGP analyses that used 2019 and 2018 (if/when available) as
#' priors for the 2021 scores.
#' 
#' In the calculation workflow, we first added the pre-calculated baseline matrices
#' to the Hawai'i entry in the `SGPstateData` object using the `addBaselineMatrices`
#' function from the `SGPmatrices` package (which also serves as a repository for
#' the baseline matrices). The 2019 configuration scripts were loaded and combined
#' into a single list object that serves to specify the exact analyses to be run.
#'
#' We then used the [`abcSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.0-0.0/topics/abcSGP)
#' function to ***a)*** prepare and validate the `Hawaii_SGP` data object contents
#' ([`prepareSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.0-0.0/topics/prepareSGP)
#' step), ***b)*** calculate 2019 consecutive-year baseline SGP estimates
#' ([`analyzeSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.0-0.0/topics/analyzeSGP)
#' step) and ***c)*** merge the results into the master longitudinal data set
#' ([`combineSGP`](https://www.rdocumentation.org/packages/SGP/versions/2.0-0.0/topics/combineSGP)
#' step).