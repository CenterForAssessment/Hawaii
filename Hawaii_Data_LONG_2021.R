###########################################################################
###
### R Syntax for construction of 2021 Hawaii LONG data file
###
###########################################################################

### Load SGP Package

require(SGP)
require(data.table)


### Load tab delimited data

Hawaii_Data_LONG_2021 <- fread("Data/Base_Files/Hawaii_Data_LONG_2021.txt")


### Tidy up data

setnames(Hawaii_Data_LONG_2021, c("Valid_Case", "grade", "lastName", "firstName", "EMH Level", "ELL Status", "Complex Area"),
	c("VALID_CASE", "Gr", "LName", "FName", "EMH.Level", "ELL_STATUS_MULTILEVEL", "Complex.Area"))
Hawaii_Data_LONG_2021[,VALID_CASE:="VALID_CASE"]
Hawaii_Data_LONG_2021[,Year:=as.character(Year)]
Hawaii_Data_LONG_2021[,IDNO:=as.character(IDNO)]
Hawaii_Data_LONG_2021[,Gr:=as.character(as.numeric(Gr))]
Hawaii_Data_LONG_2021[Gr %in% c("2", "9", "91"), VALID_CASE:="INVALID_CASE"]
Hawaii_Data_LONG_2021[,DOE_Ethnic:=as.character(DOE_Ethnic)]
Hawaii_Data_LONG_2021[,Fed7_Ethnic:=as.factor(Fed7_Ethnic)]
levels(Hawaii_Data_LONG_2021$Fed7_Ethnic)[3] <- "Black or African American"
Hawaii_Data_LONG_2021[,Fed5_Ethnic:=as.factor(Fed5_Ethnic)]
Hawaii_Data_LONG_2021[,Disadv:=as.factor(Disadv)]
levels(Hawaii_Data_LONG_2021$Disadv) <- c("Disadvantaged: No", "Disadvantaged: Yes")
Hawaii_Data_LONG_2021[,ELL:=as.factor(ELL)]
levels(Hawaii_Data_LONG_2021$ELL) <- c("ELL: No", "ELL: Yes")
Hawaii_Data_LONG_2021[,SpEd:=as.factor(SpEd)]
Hawaii_Data_LONG_2021[,Migrant:=as.factor(Migrant)]
Hawaii_Data_LONG_2021[,Scale_Score:=as.numeric(Scale_Score)]
Hawaii_Data_LONG_2021[,FSY:=as.factor(FSY)]
Hawaii_Data_LONG_2021[,ETHNICITY:=as.character(Fed7_Ethnic)]
Hawaii_Data_LONG_2021[DOE_Ethnic %in% c("Native Hawaiian", "Part-Hawaiian"), ETHNICITY:="Native Hawaiian"]
Hawaii_Data_LONG_2021[,ETHNICITY:=as.factor(ETHNICITY)]
levels(Hawaii_Data_LONG_2021$ETHNICITY)[c(3,4)] <- c("Black or African American", "Hispanic or Latino")
Hawaii_Data_LONG_2021[District=="Charter", District:="Charter Schools"]
Hawaii_Data_LONG_2021[,Complex:=as.factor(Hawaii_Data_LONG_2021$Complex)]
levels(Hawaii_Data_LONG_2021$Complex) <- as.vector(sapply(levels(Hawaii_Data_LONG_2021$Complex), capwords))
levels(Hawaii_Data_LONG_2021$Complex)[c(21,24)] <- paste(levels(Hawaii_Data_LONG_2021$Complex)[c(21,24)], "Complex")
levels(Hawaii_Data_LONG_2021$Complex)[29] <- "McKinley Complex"
Hawaii_Data_LONG_2021[,Complex.Area:=as.factor(Complex.Area)]
Hawaii_Data_LONG_2021[,Sex:=as.factor(Sex)]
Hawaii_Data_LONG_2021[,ELL_STATUS_MULTILEVEL:=as.factor(ELL_STATUS_MULTILEVEL)]
Hawaii_Data_LONG_2021[,School_Admin_Rollup:=as.factor(School_Admin_Rollup)]
Hawaii_Data_LONG_2021[,District:=as.factor(District)]
Hawaii_Data_LONG_2021[,STATE_ENROLLMENT_STATUS:=as.factor(STATE_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2021[,SCHOOL_ENROLLMENT_STATUS:=as.factor(SCHOOL_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2021[,DISTRICT_ENROLLMENT_STATUS:=as.factor(DISTRICT_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2021[FSY=="Full School Year Status: No",DISTRICT_ENROLLMENT_STATUS:="Enrolled District: No"]
Hawaii_Data_LONG_2021[,COMPLEX_ENROLLMENT_STATUS:=as.factor(COMPLEX_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2021[FSY=="Full School Year Status: No",COMPLEX_ENROLLMENT_STATUS:="Enrolled Complex: No"]
Hawaii_Data_LONG_2021[,COMPLEX_AREA_ENROLLMENT_STATUS:=as.factor(COMPLEX_AREA_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2021[FSY=="Full School Year Status: No",COMPLEX_AREA_ENROLLMENT_STATUS:="Enrolled Complex Area: No"]
Hawaii_Data_LONG_2021[,FSY_SchCode:=as.integer(FSY_SchCode)]

Hawaii_Data_LONG_2021[,HIGH_NEED_STATUS_DEMOGRAPHIC:=
        factor(2, levels=1:2, labels=c("High Need Status: ELL, Special Education, or Disadvantaged Student", "High Need Status: Non-ELL, Non-Special Education, and Non-Disadvantaged Student"))]
Hawaii_Data_LONG_2021$HIGH_NEED_STATUS_DEMOGRAPHIC[Hawaii_Data_LONG_2021$Disadv=="Disadvantaged: Yes" | Hawaii_Data_LONG_2021$ELL=="ELL Status: Yes" | Hawaii_Data_LONG_2021$SpEd=="Special Education: Yes"] <- "High Need Status: ELL, Special Education, or Disadvantaged Student"

Hawaii_Data_LONG_2021[,SCHOOL_FSY_ENROLLMENT_STATUS:=factor(2, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))]
Hawaii_Data_LONG_2021$SCHOOL_FSY_ENROLLMENT_STATUS[Hawaii_Data_LONG_2021$SCHOOL_ENROLLMENT_STATUS=="Enrolled School: No" | Hawaii_Data_LONG_2021$FSY=="Full School Year Status: No"] <- "Enrolled School: No"

### Reorder variables

my.variable.order <- c("VALID_CASE", "Domain", "Year", "Gr", "IDNO", "LName", "FName", "SCode_Admin_Rollup", "School_Admin_Rollup", "FSY_SchCode", "EMH.Level", "DCode", "District", "CCode", "Complex",
	"CACode", "Complex.Area", "Sex", "ETHNICITY", "HIGH_NEED_STATUS_DEMOGRAPHIC", "DOE_Ethnic", "Fed7_Ethnic", "Fed5_Ethnic", "Disadv", "ELL", "ELL_STATUS_MULTILEVEL", "SpEd",
	"Migrant", "Scale_Score", "Proficiency_Level", "FSY", "SCHOOL_ENROLLMENT_STATUS", "DISTRICT_ENROLLMENT_STATUS", "COMPLEX_ENROLLMENT_STATUS", "COMPLEX_AREA_ENROLLMENT_STATUS",
	"STATE_ENROLLMENT_STATUS", "SCHOOL_FSY_ENROLLMENT_STATUS")
setcolorder(Hawaii_Data_LONG_2021, my.variable.order)

### Check for duplicates
setkey(Hawaii_Data_LONG_2021, VALID_CASE, Year, Domain, Gr, IDNO, Scale_Score)
setkey(Hawaii_Data_LONG_2021, VALID_CASE, Year, Domain, Gr, IDNO)
Hawaii_Data_LONG_2021[which(duplicated(Hawaii_Data_LONG_2021, by=key(Hawaii_Data_LONG_2021)))-1, VALID_CASE:="INVALID_CASE"]

### Save results

save(Hawaii_Data_LONG_2021, file="Data/Hawaii_Data_LONG_2021.Rdata")
