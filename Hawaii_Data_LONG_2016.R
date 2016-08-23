###########################################################################
###
### R Syntax for construction of 2016 Hawaii LONG data file
###
###########################################################################

### Load SGP Package

require(SGP)
require(data.table)

### Load tab delimited data

Hawaii_Data_LONG_2016_1 <- fread("Data/Base_Files/Hawaii_Data_LONG_2016_Prep.txt", colClasses=rep("character", 34))
Hawaii_Data_LONG_2016_2 <- fread("Data/Base_Files/Hawaii_Data_LONG_2016_Courtesy_Tested Prep.txt", colClasses=rep("character", 34))
Hawaii_Data_LONG_2016 <- rbindlist(list(Hawaii_Data_LONG_2016_1, Hawaii_Data_LONG_2016_2))


### Tidy up data

setnames(Hawaii_Data_LONG_2016, c("Valid_Case", "year", "grade", "lastName", "firstName", "EMH Level", "ELL Status", "Complex Area"),
	c("VALID_CASE", "Year", "Gr", "LName", "FName", "EMH.Level", "ELL_STATUS_MULTILEVEL", "Complex.Area"))
Hawaii_Data_LONG_2016[,VALID_CASE:="VALID_CASE"]
Hawaii_Data_LONG_2016[,Gr:=as.character(as.numeric(Gr))]
Hawaii_Data_LONG_2016[Gr %in% c("1", "2", "9"), VALID_CASE:="INVALID_CASE"]
Hawaii_Data_LONG_2016[,DOE_Ethnic:=as.character(DOE_Ethnic)]
Hawaii_Data_LONG_2016[,Fed7_Ethnic:=as.factor(Fed7_Ethnic)]
Hawaii_Data_LONG_2016[,Fed5_Ethnic:=as.factor(Fed5_Ethnic)]
Hawaii_Data_LONG_2016[,Disadv:=as.factor(Disadv)]
Hawaii_Data_LONG_2016[,ELL:=as.factor(ELL)]
Hawaii_Data_LONG_2016[,SpEd:=as.factor(SpEd)]
Hawaii_Data_LONG_2016[,Migrant:=as.factor(Migrant)]
Hawaii_Data_LONG_2016[,Scale_Score:=as.numeric(Scale_Score)]
Hawaii_Data_LONG_2016[,FSY:=as.factor(FSY)]
Hawaii_Data_LONG_2016[,ETHNICITY:=as.character(Fed7_Ethnic)]
Hawaii_Data_LONG_2016[DOE_Ethnic %in% c("Native Hawaiian", "Part-Hawaiian"), ETHNICITY:="Native Hawaiian"]
Hawaii_Data_LONG_2016[,ETHNICITY:=as.factor(Hawaii_Data_LONG_2016$ETHNICITY)]
levels(Hawaii_Data_LONG_2016$ETHNICITY)[c(3,4)] <- c("Black or African American", "Hispanic or Latino")
Hawaii_Data_LONG_2016[District=="Charter", District:="Charter Schools"]
Hawaii_Data_LONG_2016[,Complex:=as.factor(Hawaii_Data_LONG_2016$Complex)]
levels(Hawaii_Data_LONG_2016$Complex) <- as.vector(sapply(levels(Hawaii_Data_LONG_2016$Complex), capwords))
levels(Hawaii_Data_LONG_2016$Complex)[c(21,24,38)] <- paste(levels(Hawaii_Data_LONG_2016$Complex)[c(21,24,38)], "Complex")
levels(Hawaii_Data_LONG_2016$Complex) <- as.vector(sapply(sapply(strsplit(sapply(levels(Hawaii_Data_LONG_2016$Complex), capwords), " "), head, -1), paste, collapse=" "))
levels(Hawaii_Data_LONG_2016$Complex)[29] <- "McKinley"
Hawaii_Data_LONG_2016[,Complex.Area:=as.factor(Complex.Area)]
Hawaii_Data_LONG_2016[,Sex:=as.factor(Sex)]
Hawaii_Data_LONG_2016[,ELL_STATUS_MULTILEVEL:=as.factor(ELL_STATUS_MULTILEVEL)]
Hawaii_Data_LONG_2016[,School_Admin_Rollup:=as.factor(School_Admin_Rollup)]
Hawaii_Data_LONG_2016[,District:=as.factor(District)]
Hawaii_Data_LONG_2016[,STATE_ENROLLMENT_STATUS:=as.factor(STATE_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2016[,SCHOOL_ENROLLMENT_STATUS:=as.factor(SCHOOL_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2016[,DISTRICT_ENROLLMENT_STATUS:=as.factor(DISTRICT_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2016[FSY=="Full School Year Status: No",DISTRICT_ENROLLMENT_STATUS:="Enrolled District: No"]
Hawaii_Data_LONG_2016[,COMPLEX_ENROLLMENT_STATUS:=as.factor(COMPLEX_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2016[FSY=="Full School Year Status: No",COMPLEX_ENROLLMENT_STATUS:="Enrolled Complex: No"]
Hawaii_Data_LONG_2016[,COMPLEX_AREA_ENROLLMENT_STATUS:=as.factor(COMPLEX_AREA_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2016[FSY=="Full School Year Status: No",COMPLEX_AREA_ENROLLMENT_STATUS:="Enrolled Complex Area: No"]
Hawaii_Data_LONG_2016[,FSY_SchCode:=as.integer(FSY_SchCode)]

Hawaii_Data_LONG_2016[,HIGH_NEED_STATUS_DEMOGRAPHIC:=
        factor(2, levels=1:2, labels=c("High Need Status: ELL, Special Education, or Disadvantaged Student", "High Need Status: Non-ELL, Non-Special Education, and Non-Disadvantaged Student"))]
Hawaii_Data_LONG_2016$HIGH_NEED_STATUS_DEMOGRAPHIC[Hawaii_Data_LONG_2016$Disadv=="Disadvantaged: Yes" | Hawaii_Data_LONG_2016$ELL=="ELL Status: Yes" | Hawaii_Data_LONG_2016$SpEd=="Special Education: Yes"] <- "High Need Status: ELL, Special Education, or Disadvantaged Student"

Hawaii_Data_LONG_2016[,SCHOOL_FSY_ENROLLMENT_STATUS:=factor(2, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))]
Hawaii_Data_LONG_2016$SCHOOL_FSY_ENROLLMENT_STATUS[Hawaii_Data_LONG_2016$SCHOOL_ENROLLMENT_STATUS=="Enrolled School: No" | Hawaii_Data_LONG_2016$FSY=="Full School Year Status: No"] <- "Enrolled School: No"

### Reorder variables

my.variable.order <- c("VALID_CASE", "Domain", "Year", "Gr", "IDNO", "LName", "FName", "SCode_Admin_Rollup", "School_Admin_Rollup", "FSY_SchCode", "EMH.Level", "DCode", "District", "CCode", "Complex",
	"CACode", "Complex.Area", "Sex", "ETHNICITY", "HIGH_NEED_STATUS_DEMOGRAPHIC", "DOE_Ethnic", "Fed7_Ethnic", "Fed5_Ethnic", "Disadv", "ELL", "ELL_STATUS_MULTILEVEL", "SpEd",
	"Migrant", "Scale_Score", "Proficiency_Level", "FSY", "SCHOOL_ENROLLMENT_STATUS", "DISTRICT_ENROLLMENT_STATUS", "COMPLEX_ENROLLMENT_STATUS", "COMPLEX_AREA_ENROLLMENT_STATUS",
	"STATE_ENROLLMENT_STATUS", "SCHOOL_FSY_ENROLLMENT_STATUS")
setcolorder(Hawaii_Data_LONG_2016, my.variable.order)


### Save results

save(Hawaii_Data_LONG_2016, file="Data/Hawaii_Data_LONG_2016.Rdata")
