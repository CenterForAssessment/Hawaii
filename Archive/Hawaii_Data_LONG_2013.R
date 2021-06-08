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
Hawaii_Data_LONG_2013$ETHNICITY[Hawaii_Data_LONG_2013$DOE_Ethnic %in% c("Native Hawaiian", "Part-Hawaiian")] <- "Native Hawaiian"
Hawaii_Data_LONG_2013$ETHNICITY <- as.factor(Hawaii_Data_LONG_2013$ETHNICITY)
levels(Hawaii_Data_LONG_2013$ETHNICITY)[c(3,4)] <- c("Black or African American", "Hispanic or Latino")
Hawaii_Data_LONG_2013$HIGH_NEEDS_STATUS_DEMOGRAPHIC <- 
	factor(2, levels=1:2, labels=c("High Need Status: ELL, Special Education, or Disadvantaged Student", "High Need Status: Non-ELL, Non-Special Education, and Non-Disadvantaged Student"))
HawaiI_Data_LONG_2013$HIGH_NEEDS_STATUS_DEMOGRAPHIC[HawaiI_Data_LONG_2013$DISADVANTAGED_STATUS=="Disadvantaged: Yes" | HawaiI_Data_LONG_2013$ELL_STATUS=="ELL Status: Yes" | Hawaii_SGP@Data$SPECIAL_EDUCATION_STATUS=="Special Education: Yes"] <- "High Need Status: ELL, Special Education, or Disadvantaged Student"

### Reorder variables

my.variable.order <- c("VALID_CASE", "Domain", "Year", "Gr", "IDNO", "LName", "FName", "SCode_Admin_Rollup", "School_Admin_Rollup", "EMH.Level", "DCode", "District", "CCode", "Complex",
	"CACode", "Complex.Area", "Sex", "ETHNICITY", "HIGH_NEEDS_STATUS_DEMOGRAPHIC", "DOE_Ethnic", "Fed7_Ethnic", "Fed5_Ethnic", "Disadv", "ELL", "ELL.Status", "SpEd", "Migrant", 
	"Scale_Score", "Proficiency_Level", "FSY", "SCHOOL_ENROLLMENT_STATUS", "DISTRICT_ENROLLMENT_STATUS", "COMPLEX_ENROLLMENT_STATUS", "COMPLEX_AREA_ENROLLMENT_STATUS", "STATE_ENROLLMENT_STATUS") 
Hawaii_Data_LONG_2013 <- Hawaii_Data_LONG_2013[,my.variable.order]


### Save results

save(Hawaii_Data_LONG_2013, file="Data/Hawaii_Data_LONG_2013.Rdata")
