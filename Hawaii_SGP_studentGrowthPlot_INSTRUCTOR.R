#################################################################################
###
### R script for producing student growth plots for instructors
###
#################################################################################

### Load SGP Package

require(SGP)
options(error=recover)
#debug(studentGrowthPlot_Styles)
#debug(visualizeSGP)


### Load data

load("Data/Hawaii_SGP.Rdata")


### Organize by Complex Area

Hawaii_SGP@Data$DISTRICT_NUMBER <- Hawaii_SGP@Data$COMPLEX_AREA_NUMBER
Hawaii_SGP@Data$DISTRICT_NAME <- Hawaii_SGP@Data$COMPLEX_AREA_NAME


### Create plots

#visualizeSGP(
#	Hawaii_SGP,
#	plot.types="studentGrowthPlot",
#	sgPlot.demo.report=TRUE)


visualizeSGP(
	Hawaii_SGP, 
	plot.types="studentGrowthPlot", 
	sgPlot.reports.by.school=FALSE, 
	sgPlot.reports.by.instructor=TRUE, 
	sgPlot.save.sgPlot.data=TRUE,
	parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SG_PLOTS=31)))
