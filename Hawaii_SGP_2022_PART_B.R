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
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
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
