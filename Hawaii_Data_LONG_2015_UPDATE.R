###########################################################################
###
### R Syntax for construction of 2015 Hawaii LONG data file
###
###########################################################################

### Load SGP Package

require(SGP)
require(data.table)

### Load tab delimited data

Hawaii_Data_LONG_2015_UPDATE <- as.data.table(read.csv("Data/Base_Files/Hawaii_Data_LONG_UPDATE_2015.csv", colClasses="character"))


### Variable names to get

variables.to.keep <- c("SchlYr", "IDNO", "LName", "Fname", "Gender", "FEDEthnic", "ELLFlag", "SPEDFlag", "DisadvnFlag", "Migrant", "CAreaCode", "CAreaName",
	"ComplexCode", "ComplexName", "SCode", "Schoolname", "SS_TOT", "PL_TOT")
old.var.names <- c("SchlYr", "Gender", "FEDEthnic", "ELLFlag", "SPEDFlag", "DisadvnFlag", "CAreaCode", "CAreaName", "ComplexCode",
	"ComplexName", "SCode", "Schoolname", "SS_TOT", "PL_TOT", "Fname")
new.var.names <- c("Year", "Sex", "Fed7_Ethnic", "ELL", "SpEd", "Disadv", "CACode", "Complex.Area", "CCode", "Complex", "SCode_Admin_Rollup",
	"School_Admin_Rollup", "Scale_Score", "Proficiency_Level", "FName")

Hawaii_Data_LONG_2015_UPDATE <- Hawaii_Data_LONG_2015_UPDATE[,variables.to.keep,with=FALSE]
setnames(Hawaii_Data_LONG_2015_UPDATE, old.var.names, new.var.names)

### Tidy up data

Hawaii_Data_LONG_2015_UPDATE$VALID_CASE <- "VALID_CASE"
Hawaii_Data_LONG_2015_UPDATE$Domain <- "READING"
Hawaii_Data_LONG_2015_UPDATE$Gr <- "3"
Hawaii_Data_LONG_2015_UPDATE$Year <- "2015"
Hawaii_Data_LONG_2015_UPDATE$Scale_Score <- as.numeric(Hawaii_Data_LONG_2015_UPDATE$Scale_Score)
Hawaii_Data_LONG_2015_UPDATE$FSY <- factor(1, levels=0:1, labels=c("Full School Year Status: No", "Full School Year Status: Yes"))
Hawaii_Data_LONG_2015_UPDATE$Fed7_Ethnic <- as.factor(Hawaii_Data_LONG_2015_UPDATE$Fed7_Ethnic)
levels(Hawaii_Data_LONG_2015_UPDATE$Fed7_Ethnic) <- c("Asian", "Hispanic", "Pacific Islander", "White")
Hawaii_Data_LONG_2015_UPDATE$ETHNICITY <- Hawaii_Data_LONG_2015_UPDATE$Fed7_Ethnic
levels(Hawaii_Data_LONG_2015_UPDATE$ETHNICITY)[2] <- "Hispanic or Latino"

Hawaii_Data_LONG_2015_UPDATE$ELL <- as.factor(Hawaii_Data_LONG_2015_UPDATE$ELL)
levels(Hawaii_Data_LONG_2015_UPDATE$ELL) <- c("ELL: No", "ELL: Yes")

Hawaii_Data_LONG_2015_UPDATE$SpEd <- as.factor(Hawaii_Data_LONG_2015_UPDATE$SpEd)
levels(Hawaii_Data_LONG_2015_UPDATE$SpEd) <- c("Special Education: No", "Special Education: Yes")

Hawaii_Data_LONG_2015_UPDATE$Disadv <- as.factor(Hawaii_Data_LONG_2015_UPDATE$Disadv)
levels(Hawaii_Data_LONG_2015_UPDATE$Disadv) <- c("Disadvantaged: No", "Disadvantaged: Yes")

Hawaii_Data_LONG_2015_UPDATE$Migrant <- as.factor(Hawaii_Data_LONG_2015_UPDATE$Migrant)
levels(Hawaii_Data_LONG_2015_UPDATE$Migrant) <- c("Migrant: No", "Migrant: Yes")

Hawaii_Data_LONG_2015_UPDATE$Complex.Area <- as.factor(Hawaii_Data_LONG_2015_UPDATE$Complex.Area)

Hawaii_Data_LONG_2015_UPDATE$CCode <- "854"
Hawaii_Data_LONG_2015_UPDATE$Complex <- factor("Kau")

Hawaii_Data_LONG_2015_UPDATE$DCode <- "5"
Hawaii_Data_LONG_2015_UPDATE$District <- factor("Hawaii")

Hawaii_Data_LONG_2015_UPDATE[Gr %in% as.character(3:5), EMH.Level:="Elementary"]
Hawaii_Data_LONG_2015_UPDATE[Gr %in% as.character(6:8), EMH.Level:="Middle"]

Hawaii_Data_LONG_2015_UPDATE$Proficiency_Level <- as.factor(Hawaii_Data_LONG_2015_UPDATE$Proficiency_Level)
levels(Hawaii_Data_LONG_2015_UPDATE$Proficiency_Level) <- c("Not Met Standard", "Nearly Met Standard", "Met Standard", "Exceeded Standard")
Hawaii_Data_LONG_2015_UPDATE$Proficiency_Level <- as.character(Hawaii_Data_LONG_2015_UPDATE$Proficiency_Level)

Hawaii_Data_LONG_2015_UPDATE$STATE_ENROLLMENT_STATUS <- factor(1, levels=0:1, labels=c("Enrolled State: No", "Enrolled State: Yes"))
Hawaii_Data_LONG_2015_UPDATE$COMPLEX_AREA_ENROLLMENT_STATUS <- factor(1, levels=0:1, labels=c("Enrolled Complex Area: No", "Enrolled Complex Area: Yes"))
Hawaii_Data_LONG_2015_UPDATE$COMPLEX_ENROLLMENT_STATUS <- factor(1, levels=0:1, labels=c("Enrolled Complex: No", "Enrolled Complex: Yes"))
Hawaii_Data_LONG_2015_UPDATE$DISTRICT_ENROLLMENT_STATUS <- factor(1, levels=0:1, labels=c("Enrolled District: No", "Enrolled District: Yes"))
Hawaii_Data_LONG_2015_UPDATE$SCHOOL_ENROLLMENT_STATUS <- factor(1, levels=0:1, labels=c("Enrolled School: No", "Enrolled School: Yes"))


### Reorder variables

my.variable.order <- c("VALID_CASE", "Domain", "Year", "Gr", "IDNO", "LName", "FName", "SCode_Admin_Rollup", "School_Admin_Rollup", "EMH.Level", "DCode", "District", "CCode", "Complex",
	"CACode", "Complex.Area", "Sex", "ETHNICITY", "Fed7_Ethnic", "Disadv", "ELL", "SpEd", "Migrant", "Scale_Score", "Proficiency_Level",
	"FSY", "SCHOOL_ENROLLMENT_STATUS", "DISTRICT_ENROLLMENT_STATUS", "COMPLEX_ENROLLMENT_STATUS", "COMPLEX_AREA_ENROLLMENT_STATUS", "STATE_ENROLLMENT_STATUS")

Hawaii_Data_LONG_2015_UPDATE <- Hawaii_Data_LONG_2015_UPDATE[,my.variable.order, with=FALSE]


### Save results

save(Hawaii_Data_LONG_2015_UPDATE, file="Data/Hawaii_Data_LONG_2015_UPDATE.Rdata")
