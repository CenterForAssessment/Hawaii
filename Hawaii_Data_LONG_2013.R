###########################################################################
###
### R Syntax for construction of 2013 Hawaii LONG data file
###
###########################################################################

### Load SGP Package

require(SGP)
require(data.table)

### Load tab delimited data

Hawaii_Data_LONG_2013 <- read.csv("Data/Base_Files/Hawaii_Data_LONG_2013.txt", sep="|")


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

Hawaii_Data_LONG_2013$VALID_CASE <- as.character(Hawaii_Data_LONG_2013$VALID_CASE)
Hawaii_Data_LONG_2013$Domain <- as.character(Hawaii_Data_LONG_2013$Domain)
Hawaii_Data_LONG_2013$Year <- as.character(Hawaii_Data_LONG_2013$Year)
Hawaii_Data_LONG_2013$Gr <- as.character(Hawaii_Data_LONG_2013$Gr)
Hawaii_Data_LONG_2013$IDNO <- as.character(Hawaii_Data_LONG_2013$IDNO)
Hawaii_Data_LONG_2013$Scale_Score <- as.numeric(Hawaii_Data_LONG_2013$Scale_Score)
Hawaii_Data_LONG_2013$FSY[Hawaii_Data_LONG_2013$FSY==""] <- NA
Hawaii_Data_LONG_2013$FSY <- droplevels(Hawaii_Data_LONG_2013$FSY)

Hawaii_Data_LONG_2013$ETHNICITY <- as.character(Hawaii_Data_LONG_2013$Fed7_Ethnic)
Hawaii_Data_LONG_2013$ETHNICITY[Hawaii_Data_LONG_2013$DOE_Ethnic %in% c("Hawaiian", "Part-Hawaiian")] <- "Native Hawaiian"
Hawaii_Data_LONG_2013$ETHNICITY <- as.factor(Hawaii_Data_LONG_2013$ETHNICITY)


### Reorder variables

my.variable.order <- c("VALID_CASE", "Domain", "Year", "Gr", "IDNO", "LName", "FName", "SCode_Admin_Rollup", "School_Admin_Rollup", "EMH.Level", "DCode", "District", "CCode", "Complex",
	"CACode", "Complex.Area", "Sex", "ETHNICITY", "DOE_Ethnic", "Fed7_Ethnic", "Fed5_Ethnic", "Disadv", "ELL", "ELL.Status", "SpEd", "Migrant", "Scale_Score", "Proficiency_Level", 
	"FSY", "SCHOOL_ENROLLMENT_STATUS", "DISTRICT_ENROLLMENT_STATUS", "COMPLEX_ENROLLMENT_STATUS", "COMPLEX_AREA_ENROLLMENT_STATUS", "STATE_ENROLLMENT_STATUS") 
Hawaii_Data_LONG_2013 <- Hawaii_Data_LONG_2013[,my.variable.order]


### Save results

save(Hawaii_Data_LONG_2013, file="Data/Hawaii_Data_LONG_2013.Rdata")
