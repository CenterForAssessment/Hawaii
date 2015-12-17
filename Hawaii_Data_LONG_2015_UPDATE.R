###########################################################################
###
### R Syntax for construction of 2015 Hawaii LONG data file
###
###########################################################################

### Load SGP Package

require(SGP)
require(data.table)

####
#### Data for missing cases
####

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
Hawaii_Data_LONG_2015_UPDATE$Sex <- as.factor(Hawaii_Data_LONG_2015_UPDATE$Sex)
levels(Hawaii_Data_LONG_2015_UPDATE$Sex) <- c("Female", "Male")

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

Hawaii_Data_LONG_2015_UPDATE <- Hawaii_Data_LONG_2015_UPDATE[, my.variable.order, with=FALSE]


####
#### ALT assessment data
####

Hawaii_Data_LONG_2013_alt <- fread("Data/Base_Files/Hawaii_Data_LONG_2013_alt_Prep.txt", colClasses=rep("character", 34))
Hawaii_Data_LONG_2014_alt <- fread("Data/Base_Files/Hawaii_Data_LONG_2014_alt_Prep.txt", colClasses=rep("character", 34))
Hawaii_Data_LONG_2015_alt <- fread("Data/Base_Files/Hawaii_Data_LONG_2015_alt_Prep.txt", colClasses=rep("character", 34))

Hawaii_Data_LONG_alt <- rbindlist(list(Hawaii_Data_LONG_2013_alt, Hawaii_Data_LONG_2014_alt, Hawaii_Data_LONG_2015_alt))

### Tidy up data

setnames(Hawaii_Data_LONG_alt, c("Valid_Case", "year", "grade", "lastName", "firstName", "EMH Level", "ELL Status", "Complex Area"),
	c("VALID_CASE", "Year", "Gr", "LName", "FName", "EMH.Level", "ELL_STATUS_MULTILEVEL", "Complex.Area"))
Hawaii_Data_LONG_alt[,VALID_CASE:="INVALID_CASE"]
Hawaii_Data_LONG_alt[,Gr:=as.character(as.numeric(Gr))]
Hawaii_Data_LONG_alt[Gr %in% c("1", "2", "9", "10", "91"), VALID_CASE:="INVALID_CASE"]
Hawaii_Data_LONG_alt[,DOE_Ethnic:=as.character(DOE_Ethnic)]
Hawaii_Data_LONG_alt[,Fed7_Ethnic:=as.factor(Fed7_Ethnic)]
Hawaii_Data_LONG_alt[,Fed5_Ethnic:=as.factor(Fed5_Ethnic)]
Hawaii_Data_LONG_alt[,Disadv:=as.factor(Disadv)]
Hawaii_Data_LONG_alt[,ELL:=as.factor(ELL)]
Hawaii_Data_LONG_alt[,SpEd:=as.factor(SpEd)]
Hawaii_Data_LONG_alt[,Migrant:=as.factor(Hawaii_Data_LONG_alt$Migrant)]
Hawaii_Data_LONG_alt[,Scale_Score:=as.numeric(Scale_Score)]
Hawaii_Data_LONG_alt[,FSY:=as.factor(FSY)]
Hawaii_Data_LONG_alt[,ETHNICITY:=as.character(Fed7_Ethnic)]
Hawaii_Data_LONG_alt[DOE_Ethnic %in% c("Native Hawaiian", "Part-Hawaiian"), ETHNICITY:="Native Hawaiian"]
Hawaii_Data_LONG_alt[,ETHNICITY:=as.factor(Hawaii_Data_LONG_alt$ETHNICITY)]
levels(Hawaii_Data_LONG_alt$ETHNICITY)[c(3,4)] <- c("Black or African American", "Hispanic or Latino")
Hawaii_Data_LONG_alt[District=="Charter", District:="Charter Schools"]
Hawaii_Data_LONG_alt[,Complex:=as.factor(Hawaii_Data_LONG_alt$Complex)]
levels(Hawaii_Data_LONG_alt$Complex) <- as.vector(sapply(levels(Hawaii_Data_LONG_alt$Complex), capwords))
levels(Hawaii_Data_LONG_alt$Complex)[c(20,23,37)] <- paste(levels(Hawaii_Data_LONG_alt$Complex)[c(20,23,37)], "Complex")
levels(Hawaii_Data_LONG_alt$Complex) <- as.vector(sapply(sapply(strsplit(sapply(levels(Hawaii_Data_LONG_alt$Complex), capwords), " "), head, -1), paste, collapse=" "))
Hawaii_Data_LONG_alt[,Complex.Area:=as.factor(Complex.Area)]
Hawaii_Data_LONG_alt[,Sex:=as.factor(Sex)]
Hawaii_Data_LONG_alt[,ELL_STATUS_MULTILEVEL:=as.factor(ELL_STATUS_MULTILEVEL)]
Hawaii_Data_LONG_alt[,School_Admin_Rollup:=as.factor(School_Admin_Rollup)]
Hawaii_Data_LONG_alt[,District:=as.factor(District)]
Hawaii_Data_LONG_alt[,STATE_ENROLLMENT_STATUS:=as.factor(STATE_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_alt[,SCHOOL_ENROLLMENT_STATUS:=as.factor(SCHOOL_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_alt[,DISTRICT_ENROLLMENT_STATUS:=as.factor(DISTRICT_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_alt[FSY=="Full School Year Status: No",DISTRICT_ENROLLMENT_STATUS:="Enrolled District: No"]
Hawaii_Data_LONG_alt[,COMPLEX_ENROLLMENT_STATUS:=as.factor(COMPLEX_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_alt[FSY=="Full School Year Status: No",COMPLEX_ENROLLMENT_STATUS:="Enrolled Complex: No"]
Hawaii_Data_LONG_alt[,COMPLEX_AREA_ENROLLMENT_STATUS:=as.factor(COMPLEX_AREA_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_alt[FSY=="Full School Year Status: No",COMPLEX_AREA_ENROLLMENT_STATUS:="Enrolled Complex Area: No"]
Hawaii_Data_LONG_alt[,FSY_SchCode:=as.integer(FSY_SchCode)]

Hawaii_Data_LONG_alt[,HIGH_NEED_STATUS_DEMOGRAPHIC:=
        factor(2, levels=1:2, labels=c("High Need Status: ELL, Special Education, or Disadvantaged Student", "High Need Status: Non-ELL, Non-Special Education, and Non-Disadvantaged Student"))]
Hawaii_Data_LONG_alt$HIGH_NEED_STATUS_DEMOGRAPHIC[Hawaii_Data_LONG_alt$Disadv=="Disadvantaged: Yes" | Hawaii_Data_LONG_alt$ELL=="ELL Status: Yes" | Hawaii_Data_LONG_alt$SpEd=="Special Education: Yes"] <- "High Need Status: ELL, Special Education, or Disadvantaged Student"

Hawaii_Data_LONG_alt[,SCHOOL_FSY_ENROLLMENT_STATUS:=factor(2, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))]
Hawaii_Data_LONG_alt$SCHOOL_FSY_ENROLLMENT_STATUS[Hawaii_Data_LONG_alt$SCHOOL_ENROLLMENT_STATUS=="Enrolled School: No" | Hawaii_Data_LONG_alt$FSY=="Full School Year Status: No"] <- "Enrolled School: No"

Hawaii_Data_LONG_alt[,VALID_CASE_STATUS_ONLY:="VALID_CASE"]

my.variable.order <- c("VALID_CASE", "Domain", "Year", "Gr", "IDNO", "LName", "FName", "SCode_Admin_Rollup", "School_Admin_Rollup", "FSY_SchCode", "EMH.Level", "DCode", "District", "CCode", "Complex",
	"CACode", "Complex.Area", "Sex", "ETHNICITY", "HIGH_NEED_STATUS_DEMOGRAPHIC", "DOE_Ethnic", "Fed7_Ethnic", "Fed5_Ethnic", "Disadv", "ELL", "ELL_STATUS_MULTILEVEL", "SpEd",
	"Migrant", "Scale_Score", "Proficiency_Level", "FSY", "SCHOOL_ENROLLMENT_STATUS", "DISTRICT_ENROLLMENT_STATUS", "COMPLEX_ENROLLMENT_STATUS", "COMPLEX_AREA_ENROLLMENT_STATUS",
	"STATE_ENROLLMENT_STATUS", "SCHOOL_FSY_ENROLLMENT_STATUS", "VALID_CASE_STATUS_ONLY")
Hawaii_Data_LONG_alt <- Hawaii_Data_LONG_alt[, my.variable.order, with=FALSE]



### Combine files

Hawaii_Data_LONG_2015_UPDATE <- rbindlist(list(Hawaii_Data_LONG_2015_UPDATE, Hawaii_Data_LONG_alt), fill=TRUE)


### Save results

save(Hawaii_Data_LONG_2015_UPDATE, file="Data/Hawaii_Data_LONG_2015_UPDATE.Rdata")
