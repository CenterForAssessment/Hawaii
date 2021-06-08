###########################################################
###
### Hawaii SGP Analysis for 2018
###
###########################################################

### Load SGP Package

require(SGP)


### Load previous SGP object and 2018 data

load("Data/Hawaii_SGP.Rdata")
load("Data/Hawaii_Data_LONG_2018.Rdata")
load("Data/Hawaii_Data_LONG_2018_INSTRUCTOR_NUMBER.Rdata")


### Load configurations

source("SGP_CONFIG/2018/READING.R")
source("SGP_CONFIG/2018/MATHEMATICS.R")

HI_CONFIG <- c(READING_2018.config, MATHEMATICS_2018.config)

### Update SGPs

Hawaii_SGP <- updateSGP(
			Hawaii_SGP,
			Hawaii_Data_LONG_2018,
			Hawaii_Data_LONG_2018_INSTRUCTOR_NUMBER,
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
