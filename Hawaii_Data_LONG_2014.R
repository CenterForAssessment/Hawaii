###########################################################################
###
### R Syntax for construction of 2014 Hawaii LONG data file
###
###########################################################################

### Load SGP Package

require(SGP)
require(data.table)

### Load tab delimited data

Hawaii_Data_LONG_2014 <- as.data.table(read.csv("Data/Base_Files/Hawaii_Data_LONG_2014.txt", sep="|", stringsAsFactors=FALSE))
SCHOOL_DATA_ANNUAL_2014_Lookup <- fread("Data/Base_Files/Corrected_and_Updated_Metadata/SCHOOL_DATA_ANNUAL_2013_Table_1.csv")

### Tidy up data

setnames(Hawaii_Data_LONG_2014, c("Valid_Case", "year", "grade", "lastName", "firstName", "ELL.Status"), c("VALID_CASE", "Year", "Gr", "LName", "FName", "ELL_STATUS_MULTILEVEL"))
Hawaii_Data_LONG_2014$VALID_CASE <- "VALID_CASE"
Hawaii_Data_LONG_2014$Year <- as.character(Hawaii_Data_LONG_2014$Year)
Hawaii_Data_LONG_2014$Gr <- as.character(Hawaii_Data_LONG_2014$Gr)
Hawaii_Data_LONG_2014$IDNO <- as.character(Hawaii_Data_LONG_2014$IDNO)
Hawaii_Data_LONG_2014$DOE_Ethnic <- as.factor(Hawaii_Data_LONG_2014$DOE_Ethnic)
Hawaii_Data_LONG_2014$Fed7_Ethnic <- as.factor(Hawaii_Data_LONG_2014$Fed7_Ethnic)
Hawaii_Data_LONG_2014$Fed5_Ethnic <- as.factor(Hawaii_Data_LONG_2014$Fed5_Ethnic)
Hawaii_Data_LONG_2014$Disadv <- as.factor(Hawaii_Data_LONG_2014$Disadv)
Hawaii_Data_LONG_2014$ELL <- as.factor(Hawaii_Data_LONG_2014$ELL)
Hawaii_Data_LONG_2014$SpEd <- as.factor(Hawaii_Data_LONG_2014$SpEd)
Hawaii_Data_LONG_2014$Migrant <- as.factor(Hawaii_Data_LONG_2014$Migrant)
Hawaii_Data_LONG_2014$Scale_Score <- as.numeric(Hawaii_Data_LONG_2014$Scale_Score)
Hawaii_Data_LONG_2014$Proficiency_Level <- factor(Hawaii_Data_LONG_2014$Proficiency_Level, levels=c("Well Below Proficiency", "Approaches Proficiency", "Meets Proficiency", "Exceeds Proficiency"), ordered=TRUE)
Hawaii_Data_LONG_2014$FSY <- as.factor(Hawaii_Data_LONG_2014$FSY)
Hawaii_Data_LONG_2014$ETHNICITY <- as.character(Hawaii_Data_LONG_2014$Fed7_Ethnic)
Hawaii_Data_LONG_2014$ETHNICITY[Hawaii_Data_LONG_2014$DOE_Ethnic %in% c("Native Hawaiian", "Part-Hawaiian")] <- "Native Hawaiian"
Hawaii_Data_LONG_2014$ETHNICITY <- as.factor(Hawaii_Data_LONG_2014$ETHNICITY)
levels(Hawaii_Data_LONG_2014$ETHNICITY)[c(3,4)] <- c("Black or African American", "Hispanic or Latino")
Hawaii_Data_LONG_2014$District[Hawaii_Data_LONG_2014$District=="Charter"] <- "Charter Schools"
Hawaii_Data_LONG_2014$Complex <- as.factor(Hawaii_Data_LONG_2014$Complex)
levels(Hawaii_Data_LONG_2014$Complex) <- as.vector(sapply(levels(Hawaii_Data_LONG_2014$Complex), capwords))
levels(Hawaii_Data_LONG_2014$Complex)[c(21,24,38)] <- paste(levels(Hawaii_Data_LONG_2014$Complex)[c(21,24,38)], "Complex")
levels(Hawaii_Data_LONG_2014$Complex) <- as.vector(sapply(sapply(strsplit(sapply(levels(Hawaii_Data_LONG_2014$Complex), capwords), " "), head, -1), paste, collapse=" "))
levels(Hawaii_Data_LONG_2014$Complex)[29] <- "McKinley"
Hawaii_Data_LONG_2014$Complex.Area <- as.factor(Hawaii_Data_LONG_2014$Complex.Area)
levels(Hawaii_Data_LONG_2014$Complex.Area)[8] <- "Hilo-Laupahoehoe-Waiakea"

Hawaii_Data_LONG_2014$Sex <- as.factor(Hawaii_Data_LONG_2014$Sex)
Hawaii_Data_LONG_2014$ELL_STATUS_MULTILEVEL <- as.factor(Hawaii_Data_LONG_2014$ELL_STATUS_MULTILEVEL)
Hawaii_Data_LONG_2014$School_Admin_Rollup <- as.factor(Hawaii_Data_LONG_2014$School_Admin_Rollup)
Hawaii_Data_LONG_2014$District <- as.factor(Hawaii_Data_LONG_2014$District)
Hawaii_Data_LONG_2014$STATE_ENROLLMENT_STATUS <- as.factor(Hawaii_Data_LONG_2014$STATE_ENROLLMENT_STATUS)
Hawaii_Data_LONG_2014$SCHOOL_ENROLLMENT_STATUS <- as.factor(Hawaii_Data_LONG_2014$SCHOOL_ENROLLMENT_STATUS)
Hawaii_Data_LONG_2014$DISTRICT_ENROLLMENT_STATUS <- as.factor(Hawaii_Data_LONG_2014$DISTRICT_ENROLLMENT_STATUS)
Hawaii_Data_LONG_2014$COMPLEX_ENROLLMENT_STATUS <- as.factor(Hawaii_Data_LONG_2014$COMPLEX_ENROLLMENT_STATUS)
Hawaii_Data_LONG_2014$COMPLEX_AREA_ENROLLMENT_STATUS <- as.factor(Hawaii_Data_LONG_2014$COMPLEX_AREA_ENROLLMENT_STATUS)

Hawaii_Data_LONG_2014$FSY_SchCode[Hawaii_Data_LONG_2014$FSY_SchCode=="NULL"] <- NA
Hawaii_Data_LONG_2014$FSY_SchCode <- as.integer(Hawaii_Data_LONG_2014$FSY_SchCode)

Hawaii_Data_LONG_2014$HIGH_NEED_STATUS_DEMOGRAPHIC <- 
        factor(2, levels=1:2, labels=c("High Need Status: ELL, Special Education, or Disadvantaged Student", "High Need Status: Non-ELL, Non-Special Education, and Non-Disadvantaged Student"))
Hawaii_Data_LONG_2014$HIGH_NEED_STATUS_DEMOGRAPHIC[Hawaii_Data_LONG_2014$DISADVANTAGED_STATUS=="Disadvantaged: Yes" | Hawaii_Data_LONG_2014$ELL_STATUS=="ELL Status: Yes" | Hawaii_Data_LONG_2014$SPECIAL_EDUCATION_STATUS=="Special Education: Yes"] <- "High Need Status: ELL, Special Education, or Disadvantaged Student"

### Reorder variables

my.variable.order <- c("VALID_CASE", "Domain", "Year", "Gr", "IDNO", "LName", "FName", "SCode_Admin_Rollup", "School_Admin_Rollup", "FSY_SchCode", "EMH.Level", "DCode", "District", "CCode", "Complex",
	"CACode", "Complex.Area", "Sex", "ETHNICITY", "HIGH_NEED_STATUS_DEMOGRAPHIC", "DOE_Ethnic", "Fed7_Ethnic", "Fed5_Ethnic", "Disadv", "ELL", "ELL_STATUS_MULTILEVEL", "SpEd", 
	"Migrant", "Scale_Score", "Proficiency_Level", "FSY", "SCHOOL_ENROLLMENT_STATUS", "DISTRICT_ENROLLMENT_STATUS", "COMPLEX_ENROLLMENT_STATUS", "COMPLEX_AREA_ENROLLMENT_STATUS", 
	"STATE_ENROLLMENT_STATUS") 
setcolorder(Hawaii_Data_LONG_2014, my.variable.order)


### Save results

save(Hawaii_Data_LONG_2014, file="Data/Hawaii_Data_LONG_2014.Rdata")
