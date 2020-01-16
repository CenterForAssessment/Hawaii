##################################################################################
###
### R script to create Instructor level summary files
###
##################################################################################


### Load packages

require(SGP)
require(data.table)


### Load Hawaii SGP object

load("Data/Hawaii_SGP.Rdata")


### Create summary files

## School_by_Instructor.txt

summary.data <- Hawaii_SGP@Summary$SCHOOL_NUMBER[['SCHOOL_NUMBER__INSTRUCTOR_NUMBER__INSTRUCTOR_ENROLLMENT_STATUS']]
summary.data <- summary.data[INSTRUCTOR_ENROLLMENT_STATUS=="Enrolled Instructor: Yes"]
fwrite(summary.data, file="School_by_Instructor.txt", quote=FALSE, sep="|")


## School_by_ContentArea_by_Instructor.txt

summary.data <- Hawaii_SGP@Summary$SCHOOL_NUMBER[['SCHOOL_NUMBER__INSTRUCTOR_NUMBER__CONTENT_AREA__INSTRUCTOR_ENROLLMENT_STATUS']]
summary.data <- summary.data[INSTRUCTOR_ENROLLMENT_STATUS=="Enrolled Instructor: Yes"]
fwrite(summary.data, file="School_by_ContentArea_by_Instructor.txt", quote=FALSE, sep="|")


## School_by_Year_by_ContentArea_by_Instructor.txt

summary.data <- Hawaii_SGP@Summary$SCHOOL_NUMBER[['SCHOOL_NUMBER__INSTRUCTOR_NUMBER__CONTENT_AREA__YEAR__INSTRUCTOR_ENROLLMENT_STATUS']]
summary.data <- summary.data[INSTRUCTOR_ENROLLMENT_STATUS=="Enrolled Instructor: Yes"]
fwrite(summary.data, file="School_by_Year_by_ContentArea_by_Instructor.txt", quote=FALSE, sep="|")


## School_by_Year_by_Instructor.txt

summary.data <- Hawaii_SGP@Summary$SCHOOL_NUMBER[['SCHOOL_NUMBER__INSTRUCTOR_NUMBER__YEAR__INSTRUCTOR_ENROLLMENT_STATUS']]
summary.data <- summary.data[INSTRUCTOR_ENROLLMENT_STATUS=="Enrolled Instructor: Yes"]
fwrite(summary.data, file="School_by_Year_by_Instructor.txt", quote=FALSE, sep="|")


## State_by_Instructor.txt

summary.data <- Hawaii_SGP@Summary$STATE[['STATE__INSTRUCTOR_NUMBER__INSTRUCTOR_ENROLLMENT_STATUS']]
summary.data <- summary.data[INSTRUCTOR_ENROLLMENT_STATUS=="Enrolled Instructor: Yes"]
fwrite(summary.data, file="State_by_Instructor.txt", quote=FALSE, sep="|")


## State_by_ContentArea_by_Instructor.txt

summary.data <- Hawaii_SGP@Summary$STATE[['STATE__INSTRUCTOR_NUMBER__CONTENT_AREA__INSTRUCTOR_ENROLLMENT_STATUS']]
summary.data <- summary.data[INSTRUCTOR_ENROLLMENT_STATUS=="Enrolled Instructor: Yes"]
fwrite(summary.data, file="State_by_ContentArea_by_Instructor.txt", quote=FALSE, sep="|")


## State_by_Year_by_ContentArea_by_Instructor.txt

summary.data <- Hawaii_SGP@Summary$STATE[['STATE__INSTRUCTOR_NUMBER__CONTENT_AREA__YEAR__INSTRUCTOR_ENROLLMENT_STATUS']]
summary.data <- summary.data[INSTRUCTOR_ENROLLMENT_STATUS=="Enrolled Instructor: Yes"]
fwrite(summary.data, file="State_by_Year_by_ContentArea_by_Instructor.txt", quote=FALSE, sep="|")


## State_by_Year_by_Instructor.txt

summary.data <- Hawaii_SGP@Summary$STATE[['STATE__INSTRUCTOR_NUMBER__YEAR__INSTRUCTOR_ENROLLMENT_STATUS']]
summary.data <- summary.data[INSTRUCTOR_ENROLLMENT_STATUS=="Enrolled Instructor: Yes"]
fwrite(summary.data, file="State_by_Year_by_Instructor.txt", quote=FALSE, sep="|")
