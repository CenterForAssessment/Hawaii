#################################################################################
###
### Syntax for producing SGPs for Hawaii
###
#################################################################################

### Load SGP Package

require(SGP)


### Load Hawaii Data

load("Data/Hawaii_Data_LONG.Rdata")


### perform abcSGP

Hawaii_SGP <- abcSGP(Hawaii_Data_LONG,
	save.intermediate.results=TRUE,
	sgPlot.demo.report=TRUE,
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=30, BASELINE_PERCENTILES=30, PROJECTIONS=14, LAGGED_PROJECTIONS=14, SUMMARY=30, GA_PLOTS=10, SG_PLOTS=1)))


### Save results

save(Hawaii_SGP, file="Data/Hawaii_SGP.Rdata")
