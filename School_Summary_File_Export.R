##################################################################################
###
### R script to create Instructor level summary files
###
##################################################################################

### Load packages

require(SGP)
require(data.table)


### Load Hawaii SGP object

#load("Data/Hawaii_SGP.Rdata")


### Create summary files

## School_Number_FSY_by_Content_Area_by_Year.txt

summary.data <- Hawaii_SGP@Summary$SCHOOL_NUMBER_FSY[['SCHOOL_NUMBER_FSY__CONTENT_AREA__YEAR__SCHOOL_FSY_ENROLLMENT_STATUS']]
summary.data <- summary.data[SCHOOL_FSY_ENROLLMENT_STATUS=="Enrolled School: Yes"]
fwrite(summary.data, file="School_Number_FSY_by_Content_Area_by_Year.txt", quote=FALSE, sep="|")


## School_Number_by_Content_Area_by_Year.txt

summary.data <- Hawaii_SGP@Summary$SCHOOL_NUMBER[['SCHOOL_NUMBER__CONTENT_AREA__YEAR__SCHOOL_ENROLLMENT_STATUS']]
summary.data <- summary.data[SCHOOL_ENROLLMENT_STATUS=="Enrolled School: Yes"]
fwrite(summary.data, file="School_Number_by_Content_Area_by_Year.txt", quote=FALSE, sep="|")


## School_Number_by_EMH_by_Content_Area_by_Year.txt

summary.data <- Hawaii_SGP@Summary$SCHOOL_NUMBER[['SCHOOL_NUMBER__EMH_LEVEL__CONTENT_AREA__YEAR__SCHOOL_ENROLLMENT_STATUS']]
summary.data <- summary.data[SCHOOL_ENROLLMENT_STATUS=="Enrolled School: Yes"]
fwrite(summary.data, file="School_Number_by_EMH_by_Content_Area_by_Year.txt", quote=FALSE, sep="|")
