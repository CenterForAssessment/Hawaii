################################################################################
###                                                                          ###
###                 Hawaii COVID Skip-year SGP analyses for 2021             ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/Hawaii_SGP.Rdata")
load("Data/Hawaii_Data_LONG_2021.Rdata")

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("HI", "2021")

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2021/PART_A/READING.R")
source("SGP_CONFIG/2021/PART_A/MATHEMATICS.R")

HI_CONFIG <- c(READING_2021.config, MATHEMATICS_2021.config)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

#####
###   Run updateSGP :which(x, arr.ind = FALSE, useNames = TRUE)analysis
#####

Hawaii_SGP <- updateSGP(
        what_sgp_object = Hawaii_SGP,
        with_sgp_data_LONG = Hawaii_Data_LONG_2021,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = HI_CONFIG,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
)

###   Save results
#save(Hawaii_SGP, file="Hawaii_SGP.Rdata")
