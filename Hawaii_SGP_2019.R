###########################################################
###
### Hawaii SGP Analysis for 2019
###
###########################################################

### Load SGP Package

require(SGP)


### Load previous SGP object and 2019 data

load("Data/Hawaii_SGP.Rdata")
load("Data/Hawaii_Data_LONG_2019.Rdata")
load("Data/Hawaii_Data_LONG_2019_INSTRUCTOR_NUMBER.Rdata")


### Load configurations

source("SGP_CONFIG/2019/READING.R")
source("SGP_CONFIG/2019/MATHEMATICS.R")

HI_CONFIG <- c(READING_2019.config, MATHEMATICS_2019.config)

### Update SGPs

Hawaii_SGP <- updateSGP(
			Hawaii_SGP,
			Hawaii_Data_LONG_2019,
			Hawaii_Data_LONG_2019_INSTRUCTOR_NUMBER,
			steps=c("prepareSGP", "analyzeSGP", "combineSGP", "summarizeSGP", "outputSGP"),
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			sgp.target.scale.scores=TRUE,
			save.intermediate.results=FALSE,
			sgPlot.demo.report=TRUE,
			sgp.config=HI_CONFIG,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=2,  PROJECTIONS=2, LAGGED_PROJECTIONS=2, SUMMARY=2, GA_PLOTS=2, SG_PLOTS=1)))


### Save results

#save(Hawaii_SGP, file="Data/Hawaii_SGP.Rdata")
