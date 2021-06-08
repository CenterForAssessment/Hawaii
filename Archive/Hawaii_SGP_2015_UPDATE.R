###########################################################
###
### Hawaii SGP Analysis for 2015
###
###########################################################

### Load SGP Package

require(SGP)
require(data.table)


### Load previous SGP object and 2015 data

load("Data/Hawaii_SGP.Rdata")
load("Data/Hawaii_Data_LONG_2015_UPDATE.Rdata")


### Modify SCHOOL_, DISTRICT_, and STATE_ enrollment status for courtesy tested students and add in UPDATE data

Courtesy_IDs <- read.csv("Data/Base_Files/Hawaii_Data_LONG_2015_Courtesy_Tested_Prep.txt")
names(Courtesy_IDs) <- "ID"
Hawaii_SGP@Data$STATE_ENROLLMENT_STATUS[Hawaii_SGP@Data$ID %in% Courtesy_IDs$ID & Hawaii_SGP@Data$YEAR=="2015"] <- "Enrolled State: No"
Hawaii_SGP@Data$DISTRICT_ENROLLMENT_STATUS[Hawaii_SGP@Data$ID %in% Courtesy_IDs$ID & Hawaii_SGP@Data$YEAR=="2015"] <- "Enrolled District: No"
Hawaii_SGP@Data$SCHOOL_ENROLLMENT_STATUS[Hawaii_SGP@Data$ID %in% Courtesy_IDs$ID & Hawaii_SGP@Data$YEAR=="2015"] <- "Enrolled School: No"

Hawaii_Data_LONG_2015_UPDATE <- prepareSGP(Hawaii_Data_LONG_2015_UPDATE)@Data
Hawaii_SGP@Data <- rbindlist(list(Hawaii_SGP@Data, Hawaii_Data_LONG_2015_UPDATE), fill=TRUE)


### prepareSGP

Hawaii_SGP <- prepareSGP(Hawaii_SGP)


### summarizeSGP

Hawaii_SGP <- summarizeSGP(Hawaii_SGP, parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SUMMARY=8)))


### outputSGP

outputSGP(Hawaii_SGP, output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data", "WIDE_Data", "INSTRUCTOR_Data", "SchoolView"))


### Save results

save(Hawaii_SGP, file="Data/Hawaii_SGP.Rdata")
