###########################################################################
###
### R Syntax for construction of 2013 Hawaii LONG data file
###
###########################################################################

### Load SGP Package

require(SGP)
require(data.table)

### Load tab delimited data

Hawaii_Data_LONG_2013_UPDATE <- read.csv("Data/Base_Files/Hawaii_Data_LONG_2013_UPDATE.txt", sep="|")


### Names

names(Hawaii_Data_LONG_2013_UPDATE)[c(1,3)] <- c("VALID_CASE", "Year")

### Tidy up data

Hawaii_Data_LONG_2013_UPDATE$VALID_CASE <- toupper(as.character(Hawaii_Data_LONG_2013_UPDATE$VALID_CASE))
Hawaii_Data_LONG_2013_UPDATE$Domain <- as.character(Hawaii_Data_LONG_2013_UPDATE$Domain)
Hawaii_Data_LONG_2013_UPDATE$Year <- as.character(Hawaii_Data_LONG_2013_UPDATE$Year)
Hawaii_Data_LONG_2013_UPDATE$Gr <- as.character(Hawaii_Data_LONG_2013_UPDATE$Gr)
Hawaii_Data_LONG_2013_UPDATE$IDNO <- as.character(Hawaii_Data_LONG_2013_UPDATE$IDNO)
Hawaii_Data_LONG_2013_UPDATE$Scale_Score <- as.numeric(Hawaii_Data_LONG_2013_UPDATE$Scale_Score)
Hawaii_Data_LONG_2013_UPDATE$FSY[Hawaii_Data_LONG_2013_UPDATE$FSY==""] <- NA
Hawaii_Data_LONG_2013_UPDATE$FSY <- droplevels(Hawaii_Data_LONG_2013_UPDATE$FSY)

Hawaii_Data_LONG_2013_UPDATE$ETHNICITY <- as.character(Hawaii_Data_LONG_2013_UPDATE$Fed7_Ethnic)
Hawaii_Data_LONG_2013_UPDATE$ETHNICITY[Hawaii_Data_LONG_2013_UPDATE$DOE_Ethnic %in% c("Native Hawaiian", "Part-Hawaiian")] <- "Native Hawaiian"
Hawaii_Data_LONG_2013_UPDATE$ETHNICITY <- as.factor(Hawaii_Data_LONG_2013_UPDATE$ETHNICITY)
levels(Hawaii_Data_LONG_2013_UPDATE$ETHNICITY)[3] <- "Hispanic or Latino"

### Reorder variables

my.variable.order <- c("VALID_CASE", "Domain", "Year", "Gr", "IDNO", "LName", "FName", "SCode_Admin_Rollup", "School_Admin_Rollup", "EMH.Level", "DCode", "District", "CCode", "Complex",
	"CACode", "Complex.Area", "Sex", "ETHNICITY", "DOE_Ethnic", "Fed7_Ethnic", "Fed5_Ethnic", "Disadv", "ELL", "ELL.Status", "SpEd", "Migrant", "Scale_Score", "Proficiency_Level", 
	"FSY", "SCHOOL_ENROLLMENT_STATUS", "DISTRICT_ENROLLMENT_STATUS", "COMPLEX_ENROLLMENT_STATUS", "COMPLEX_AREA_ENROLLMENT_STATUS", "STATE_ENROLLMENT_STATUS") 
Hawaii_Data_LONG_2013_UPDATE <- Hawaii_Data_LONG_2013_UPDATE[,my.variable.order]


### Save results

save(Hawaii_Data_LONG_2013_UPDATE, file="Data/Hawaii_Data_LONG_2013_UPDATE.Rdata")
