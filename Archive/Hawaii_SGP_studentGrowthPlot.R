##############################################################
###
### File for creation of student growth plots
###
##############################################################

### Load SGP Package

require(SGP)


### Load Data

load("Data/Hawaii_SGP.Rdata")
#load("Data/Hawaii_studentGrowthPlot_Data.Rdata")


### Make DISTRICT_NUMBER COMPLEX_AREA_NUMBER

Hawaii_SGP@Data$DISTRICT_NUMBER <- Hawaii_SGP@Data$COMPLEX_AREA_NUMBER
Hawaii_SGP@Data$DISTRICT_NAME <- Hawaii_SGP@Data$COMPLEX_AREA_NAME


### Missing schools

#missing.schools <- sapply(strsplit(list.files("Errors", pattern="school_catalog"), "_|[.]"), '[', 4)


### Create student reports

visualizeSGP(
	Hawaii_SGP,
	state="HI",
	plot.types="studentGrowthPlot",
	sgPlot.save.sgPlot.data=TRUE,
	sgPlot.produce.plots=FALSE)
#	sgPlot.schools=missing.schools, 
#	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SG_PLOTS=30)))
