################################################################################
###                                                                          ###
###   Hawaii Learning Loss Analyses -- 2019 Baseline Growth Projections    ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)

###   Load data from baseline SGP analyses
load("Data/Hawaii_SGP.Rdata")

###   Add single-cohort baseline matrices to SGPstateData
SGPstateData <- SGPmatrices::addBaselineMatrices("HI", "2021")

###   Read in BASELINE projections configuration scripts and combine
source("SGP_CONFIG/2019/BASELINE/Projections/READING.R")
source("SGP_CONFIG/2019/BASELINE/Projections/MATHEMATICS.R")

HI_2019_Baseline_Config <- c(
	READING_2019.config,
	MATHEMATICS_2019.config
)

#####
###   Run projections analysis - run abcSGP on object from BASELINE SGP analysis
#####

###   Update SGPstateData with grade/course/lag progression information
source("SGP_CONFIG/2019/BASELINE/Projections/Skip_Year_Projections_MetaData.R")

Hawaii_SGP <- abcSGP(
        sgp_object = Hawaii_SGP,
        steps = c("prepareSGP", "analyzeSGP"), # no changes to @Data - don't combine or output
        sgp.config = HI_2019_Baseline_Config,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = FALSE,
        sgp.projections.baseline = TRUE, # Need P50_PROJ_YEAR_1_CURRENT for Ho's Fair Trend/Equity Check metrics
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = list(
		BACKEND = "PARALLEL",
		WORKERS=list(PROJECTIONS=8))
)

###   Save results

save(Hawaii_SGP, file="Data/Hawaii_SGP.Rdata")
