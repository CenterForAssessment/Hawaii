###########################################################
###
### Hawaii SGP Analysis for 2014
###
###########################################################

### Load SGP Package

require(SGP)


### Load previous SGP object and 2014 data

load("Data/Hawaii_SGP.Rdata")
load("Data/Hawaii_Data_LONG_2014.Rdata")
load("Data/Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER.Rdata")


### Update SGPs

Hawaii_SGP <- updateSGP(
			Hawaii_SGP,
			Hawaii_Data_LONG_2014,
			Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER,
			sgPlot.demo.report=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SUMMARY=4, GA_PLOTS=4, SG_PLOTS=1)))


### Save results

save(Hawaii_SGP, file="Data/Hawaii_SGP.Rdata")
