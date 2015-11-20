###########################################################################
###
### R Syntax for construction of 2013 Hawaii LONG data file
###
###########################################################################

### Load SGP Package

require(SGP)
require(data.table)

### Load tab delimited data

Hawaii_Data_LONG_2013_ADDITIONAL_CASES <- read.csv("Data/Base_Files/Hawaii_Data_LONG_2013_ADDITIONAL_CASES.txt", sep="|")


### Names

names(Hawaii_Data_LONG_2013_ADDITIONAL_CASES)[c(1,3)] <- c("VALID_CASE", "Year")

### Tidy up data

Hawaii_Data_LONG_2013_ADDITIONAL_CASES$VALID_CASE <- toupper(as.character(Hawaii_Data_LONG_2013_ADDITIONAL_CASES$VALID_CASE))
Hawaii_Data_LONG_2013_ADDITIONAL_CASES$Domain <- as.character(Hawaii_Data_LONG_2013_ADDITIONAL_CASES$Domain)
Hawaii_Data_LONG_2013_ADDITIONAL_CASES$Year <- as.character(Hawaii_Data_LONG_2013_ADDITIONAL_CASES$Year)
Hawaii_Data_LONG_2013_ADDITIONAL_CASES$Gr <- as.character(Hawaii_Data_LONG_2013_ADDITIONAL_CASES$Gr)
Hawaii_Data_LONG_2013_ADDITIONAL_CASES$IDNO <- as.character(Hawaii_Data_LONG_2013_ADDITIONAL_CASES$IDNO)
Hawaii_Data_LONG_2013_ADDITIONAL_CASES$Scale_Score <- as.numeric(Hawaii_Data_LONG_2013_ADDITIONAL_CASES$Scale_Score)
Hawaii_Data_LONG_2013_ADDITIONAL_CASES$FSY[Hawaii_Data_LONG_2013_ADDITIONAL_CASES$FSY==""] <- NA
Hawaii_Data_LONG_2013_ADDITIONAL_CASES$FSY <- droplevels(Hawaii_Data_LONG_2013_ADDITIONAL_CASES$FSY)

Hawaii_Data_LONG_2013_ADDITIONAL_CASES$ETHNICITY <- as.character(Hawaii_Data_LONG_2013_ADDITIONAL_CASES$Fed7_Ethnic)
Hawaii_Data_LONG_2013_ADDITIONAL_CASES$ETHNICITY[Hawaii_Data_LONG_2013_ADDITIONAL_CASES$DOE_Ethnic %in% c("Native Hawaiian", "Part-Hawaiian")] <- "Native Hawaiian"
Hawaii_Data_LONG_2013_ADDITIONAL_CASES$ETHNICITY <- as.factor(Hawaii_Data_LONG_2013_ADDITIONAL_CASES$ETHNICITY)
levels(Hawaii_Data_LONG_2013_ADDITIONAL_CASES$ETHNICITY)[3] <- "Hispanic or Latino"

### Reorder variables

my.variable.order <- c("VALID_CASE", "Domain", "Year", "Gr", "IDNO", "LName", "FName", "SCode_Admin_Rollup", "School_Admin_Rollup", "EMH.Level", "DCode", "District", "CCode", "Complex",
	"CACode", "Complex.Area", "Sex", "ETHNICITY", "DOE_Ethnic", "Fed7_Ethnic", "Fed5_Ethnic", "Disadv", "ELL", "ELL.Status", "SpEd", "Migrant", "Scale_Score", "Proficiency_Level", 
	"FSY", "SCHOOL_ENROLLMENT_STATUS", "DISTRICT_ENROLLMENT_STATUS", "COMPLEX_ENROLLMENT_STATUS", "COMPLEX_AREA_ENROLLMENT_STATUS", "STATE_ENROLLMENT_STATUS") 
Hawaii_Data_LONG_2013_ADDITIONAL_CASES <- Hawaii_Data_LONG_2013_ADDITIONAL_CASES[,my.variable.order]


### Save results

save(Hawaii_Data_LONG_2013_ADDITIONAL_CASES, file="Data/Hawaii_Data_LONG_2013_ADDITIONAL_CASES.Rdata")
