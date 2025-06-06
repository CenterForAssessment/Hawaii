######################################################################################
###                                                                                ###
###                Hawaii SGP PRELIMINARY analyses for 2025                        ###
###                August 2025 update with updated 2025 data                       ###
###                                                                                ###
######################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

### Load SGP object data
load("Data/Hawaii_SGP.Rdata")
load("Data/Hawaii_Data_LONG_2025.Rdata")

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("HI", "2025")

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2025/READING.R")
source("SGP_CONFIG/2025/MATHEMATICS.R")

HI_CONFIG <- c(READING_2025.config, MATHEMATICS_2025.config)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))


#####
###   Run cohort-referenced abcSGP analysis
#####

Hawaii_SGP <- updateSGP(
        what_sgp_object = Hawaii_SGP,
        with_sgp_data_LONG = Hawaii_Data_LONG_2025,
	steps = c("prepareSGP", "analyzeSGP", "combineSGP", "summarizeSGP", "outputSGP"),
        sgp.config = HI_CONFIG,
        sgp.percentiles = TRUE,
        sgp.projections = TRUE,
        sgp.projections.lagged = TRUE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = TRUE,
        sgp.projections.lagged.baseline = TRUE,
	sgp.use.my.coefficient.matrices = TRUE,
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
)


###   Save results
save(Hawaii_SGP, file="Data/Hawaii_SGP.Rdata")
