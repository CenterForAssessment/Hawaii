###########################################################################
###
### R Syntax for construction of 2013 Hawaii LONG data file
###
###########################################################################

### Load SGP Package

require(SGP)
require(data.table)

### Load tab delimited data

HST_2013 <- read.delim("Data/Base_Files/Hawaii_SGP_Data_2013.txt", header=TRUE)


### Create LONG data

attach(HST_2013)
Hawaii_Data_LONG_2013 <- data.table(
			Domain=c(rep("READING", dim(HST_2013)[1]), rep("MATHEMATICS", dim(HST_2013)[1])),
			Year="2013",
			IDNO=rep(as.character(IDNO), 2),
			LName=rep(as.character(LName), 2),
			FName=rep(as.character(FName), 2),
			Sex=rep(as.character(gender), 2),
			SCode_Admin_Rollup=rep(SC, 2),
			School_Admin_Rollup=rep(as.character(School), 2),
			Gr=rep(as.character(Gr), 2),
			FSY=rep(as.character(FSY), 2),
			DOE_Ethnic=rep(StateEthnicity, 2),
			Fed7_Ethnic=rep(FedEthnicity, 2),
			Disadv=rep(Lunch, 2),
			ELL=rep(ELL, 2),
			SpEd=rep(SPED, 2),
			Migrant=rep(Migrant, 2),
			Scale_Score=c(R_SS_Tot, M_SS_Tot),
			Proficiency_Level=c(R_PL_Tot, M_PL_Tot),
			Test_Name=c(as.character(R_Test_Name), as.character(M_Test_Name)))
detach(HST_2013)


### Tidy up data

# Subset out HSA test (remove Hawaiian)

Hawaii_Data_LONG_2013$Test_Name[Hawaii_Data_LONG_2013$Test_Name==""] <- NA
tmp.tests.to.remove <- c("HSA_OP-HAW-FX-Mathematics-3", "HSA_OP-HAW-FX-Mathematics-4", "HSA_OP-HAW-FX-Reading-3", "HSA_OP-HAW-FX-Reading-4")
Hawaii_Data_LONG_2013 <- subset(Hawaii_Data_LONG_2013, !is.na(Test_Name) & !Test_Name %in% tmp.tests.to.remove)
Hawaii_Data_LONG_2013$Test_Name <- NULL


# Correct modify individual variables

Hawaii_Data_LONG_2013$LName <- as.factor(Hawaii_Data_LONG_2013$LName)
Hawaii_Data_LONG_2013$FName <- as.factor(Hawaii_Data_LONG_2013$FName)
levels(Hawaii_Data_LONG_2013$LName) <- sapply(levels(Hawaii_Data_LONG_2013$LName), capwords)
levels(Hawaii_Data_LONG_2013$FName) <- sapply(levels(Hawaii_Data_LONG_2013$FName), capwords)

Hawaii_Data_LONG_2013$Sex <- as.factor(Hawaii_Data_LONG_2013$Sex)
levels(Hawaii_Data_LONG_2013$Sex) <- c("Female", "Male")

Hawaii_Data_LONG_2013$School_Admin_Rollup <- as.factor(Hawaii_Data_LONG_2013$School_Admin_Rollup)

Hawaii_Data_LONG_2013$FSY <- as.factor(Hawaii_Data_LONG_2013$FSY)
Hawaii_Data_LONG_2013$FSY[Hawaii_Data_LONG_2013$FSY==""] <- NA
Hawaii_Data_LONG_2013$FSY <- droplevels(Hawaii_Data_LONG_2013$FSY)
levels(Hawaii_Data_LONG_2013$FSY) <- c("Full School Year Status: No", "Full School Year Status: Yes")

levels(Hawaii_Data_LONG_2013$Fed7_Ethnic)[which(levels(Hawaii_Data_LONG_2013$Fed7_Ethnic)=="Multiple")] <= "Two or more races"

Hawaii_Data_LONG_2013$Fed5_Ethnic <- Hawaii_Data_LONG_2013$Fed7_Ethnic
levels(Hawaii_Data_LONG_2013$Fed5_Ethnic) <- c("American Indian or Alaska Native", "Asian/Pacific Islander", "Black or African American", "Hispanic or Latino", "Asian/Pacific Islander", 
	"Asian/Pacific Islander", "White") 

levels(Hawaii_Data_LONG_2013$Disadv) <- c("Disadvantaged: No", "Disadvantaged: Yes")

levels(Hawaii_Data_LONG_2013$ELL) <- c("ELL: No", "ELL: Yes")

levels(Hawaii_Data_LONG_2013$SpEd) <- c("Special Education: No", "Special Education: Yes")

levels(Hawaii_Data_LONG_2013$Migrant) <- c("Migrant: No", "Migrant: Yes")

Hawaii_Data_LONG_2013$Scale_Score <- as.numeric(Hawaii_Data_LONG_2013$Scale_Score)

Hawaii_Data_LONG_2013$Proficiency_Level <- as.factor(Hawaii_Data_LONG_2013$Proficiency_Level)
levels(Hawaii_Data_LONG_2013$Proficiency_Level) <- c("Well Below Proficiency", "Approaches Proficiency", "Meets Proficiency", "Exceeds Proficiency")

Hawaii_Data_LONG_2013$SCHOOL_ENROLLMENT_STATUS <- factor(1, levels=0:1, c("Enrolled School: No", "Enrolled School: Yes"))
Hawaii_Data_LONG_2013$SCHOOL_ENROLLMENT_STATUS[Hawaii_Data_LONG_2013$FSY=="Full School Year Status: No"] <- "Enrolled School: No"

Hawaii_Data_LONG_2013$DISTRICT_ENROLLMENT_STATUS <- factor(1, levels=0:1, c("Enrolled District: No", "Enrolled District: Yes"))
Hawaii_Data_LONG_2013$COMPLEX_ENROLLMENT_STATUS <- factor(1, levels=0:1, c("Enrolled Complex: No", "Enrolled Complex: Yes"))
Hawaii_Data_LONG_2013$COMPLEX_AREA_ENROLLMENT_STATUS <- factor(1, levels=0:1, c("Enrolled Complex Area: No", "Enrolled Complex Area: Yes"))
Hawaii_Data_LONG_2013$STATE_ENROLLMENT_STATUS <- factor(1, levels=0:1, c("Enrolled State: No", "Enrolled State: Yes"))
Hawaii_Data_LONG_2013$VALID_CASE <- "VALID_CASE"



### Reorder variables

my.variable.order <- c("VALID_CASE", "Domain", "Year", "Gr", "IDNO", "LName", "FName", "SCode_Admin_Rollup", "School_Admin_Rollup", "Sex", "DOE_Ethnic", "Fed7_Ethnic", "Fed5_Ethnic", 
	"Disadv", "ELL", "SpEd", "Migrant", "Scale_Score", "Proficiency_Level", "FSY", "SCHOOL_ENROLLMENT_STATUS", "DISTRICT_ENROLLMENT_STATUS", "COMPLEX_ENROLLMENT_STATUS", 
	"COMPLEX_AREA_ENROLLMENT_STATUS", "STATE_ENROLLMENT_STATUS") 
Hawaii_Data_LONG_2013 <- Hawaii_Data_LONG_2013[,my.variable.order,with=FALSE]


### Save results

save(Hawaii_Data_LONG_2013, file="Data/Hawaii_Data_LONG_2013.Rdata")
