################################################################################
###                                                                          ###
###   Hawaii Learning Loss Analyses -- 2019 Baseline Growth Percentiles    ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)

###   Load data and remove years that will not be used.
load("Data/Hawaii_SGP_LONG_Data.Rdata")

### Test for BASELINE related variable in LONG data and NULL out if they exist
if (length(tmp.names <- grep("BASELINE|SS", names(Hawaii_SGP_LONG_Data))) > 0) {
		Hawaii_SGP_LONG_Data[,eval(tmp.names):=NULL]
}

###   Add single-cohort baseline matrices to SGPstateData
SGPstateData <- SGPmatrices::addBaselineMatrices("HI", "2021")

###   Read in BASELINE percentiles configuration scripts and combine
source("SGP_CONFIG/2019/BASELINE/Percentiles/READING.R")
source("SGP_CONFIG/2019/BASELINE/Percentiles/MATHEMATICS.R")

HI_2019_Baseline_Config <- c(
	READING_2019.config,
	MATHEMATICS_2019.config
)

#####
###   Run BASELINE SGP analysis - create new Hawaii_SGP object with historical data
#####

###   Temporarily set names of prior scores from sequential/cohort analyses
data.table::setnames(Hawaii_SGP_LONG_Data,
	c("SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED"),
	c("SS_PRIOR_COHORT", "SS_PRIOR_STD_COHORT"))

SGPstateData[["HI"]][["Assessment_Program_Information"]][["CSEM"]] <- NULL

Hawaii_SGP <- abcSGP(
        sgp_object = Hawaii_SGP_LONG_Data,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = HI_2019_Baseline_Config,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,  #  Skip year SGPs for 2021 comparisons
        sgp.projections.baseline = FALSE, #  Calculated in next step
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = list(
			BACKEND = "PARALLEL",
			WORKERS=list(BASELINE_PERCENTILES=5))
)


###   Re-set and rename prior scores (one set for sequential/cohort, another for skip-year/baseline)

data.table::setnames(Hawaii_SGP@Data,
  c("SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED", "SS_PRIOR_COHORT", "SS_PRIOR_STD_COHORT"),
  c("SCALE_SCORE_PRIOR_BASELINE", "SCALE_SCORE_PRIOR_STANDARDIZED_BASELINE", "SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED"))


###   Save results

save(Hawaii_SGP, file="Data/Hawaii_SGP.Rdata")
