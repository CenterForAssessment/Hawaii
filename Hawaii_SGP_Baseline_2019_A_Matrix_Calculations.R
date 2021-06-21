################################################################################
###                                                                          ###
###       Hawaii Learning Loss Analyses -- Create Baseline Matrices        ###
###                                                                          ###
################################################################################

### Load necessary packages
require(SGP)

###   Load the results data from the 'official' 2019 SGP analyses
load("Data/Hawaii_SGP_LONG_Data.Rdata")

###   Create a smaller subset of the LONG data to work with.
Hawaii_Baseline_Data <- data.table::data.table(Hawaii_SGP_LONG_Data[YEAR > 2015,
	c("ID", "CONTENT_AREA", "YEAR", "GRADE", "SCALE_SCORE", "ACHIEVEMENT_LEVEL", "VALID_CASE"),])

###   Read in Baseline SGP Configuration Scripts and Combine
source("SGP_CONFIG/2019/BASELINE/Matrices/READING.R")
source("SGP_CONFIG/2019/BASELINE/Matrices/MATHEMATICS.R")

HI_BASELINE_CONFIG <- c(
	READING_BASELINE.config,
	MATHEMATICS_BASELINE.config
)


###   Create Baseline Matrices

Hawaii_SGP <- prepareSGP(Hawaii_Baseline_Data, create.additional.variables=FALSE)

HI_Baseline_Matrices <- baselineSGP(
				Hawaii_SGP,
				sgp.baseline.config=HI_BASELINE_CONFIG,
				return.matrices.only=TRUE,
				calculate.baseline.sgps=FALSE,
				goodness.of.fit.print=FALSE,
				parallel.config = list(
					BACKEND="PARALLEL", WORKERS=list(TAUS=4))
)

###   Save results

save(HI_Baseline_Matrices, file="Data/HI_Baseline_Matrices.Rdata")
