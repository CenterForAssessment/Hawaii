#+ include = FALSE, purl = FALSE
###########################################################################
###
###   R Syntax for construction of 2023 Hawaii LONG data file
###
###########################################################################

#' ## Data Preparation
#' 
#' The data preparation step involves taking data provided by the HIDOE and
#' producing a `.Rdata` file that will subsequently be analyzed using the `SGP`
#' software. This process is carried out annually as new data becomes available.
#' 
#' For the 2023 Hawai'i SBA data preparation and cleaning, we first modify
#' values of student demographic and enrollment status variables to match with
#' values and factor levels that have been used in previous years or as
#' required to conform to the `SGP` package conventions.
#' 
#' The full school year attendance for students is then used to verify and
#' modify (if necessary) the enrollment status variables. This will ensure that
#' any subsequent school, district and complex growth and achievement aggregates
#' that are produced after the SGP calculations will contain the appropriate
#' students. Note that  this does not impact which students will be included in
#' the growth calculations.
#'
#' Finally, the 2023 SBA data was examined to identify invalid records. 
#' Student records were flagged as "invalid" based on the following criteria:
#'
#' * Student records with a `GRADE` level value outside of the 3-8 and 11 range.
#' * Students with duplicate records. In these instances, a student's highest
#'   scale score is retained as the "valid" case for the SGP analyses.

#+ include = FALSE, purl = FALSE, eval = FALSE

### Load SGP Package
require(SGP)
require(data.table)


### Load tab delimited data
Hawaii_Data_LONG_2023 <- fread("Data/Base_Files/Hawaii_Data_LONG_2023.txt")


### Tidy up data
setnames(Hawaii_Data_LONG_2023, c("Valid_Case", "grade", "lastName", "firstName", "EMH Level", "ELL Status", "Complex Area"),
	c("VALID_CASE", "Gr", "LName", "FName", "EMH.Level", "ELL_STATUS_MULTILEVEL", "Complex.Area"))
Hawaii_Data_LONG_2023[,VALID_CASE:="VALID_CASE"]
Hawaii_Data_LONG_2023[,Year:=as.character(Year)]
Hawaii_Data_LONG_2023[,IDNO:=as.character(IDNO)]
Hawaii_Data_LONG_2023[,Gr:=as.character(as.numeric(Gr))]
Hawaii_Data_LONG_2023[Gr %in% c("9", "10", "12"), VALID_CASE:="INVALID_CASE"]
Hawaii_Data_LONG_2023[,Fed7_Ethnic:=as.factor(Fed7_Ethnic)]
levels(Hawaii_Data_LONG_2023$Fed7_Ethnic)[3] <- "Black or African American"
Hawaii_Data_LONG_2023[,Fed5_Ethnic:=as.factor(Fed5_Ethnic)]
Hawaii_Data_LONG_2023[,Disadv:=as.factor(Disadv)]
levels(Hawaii_Data_LONG_2023$Disadv) <- c("Disadvantaged: No", "Disadvantaged: Yes")
Hawaii_Data_LONG_2023[,ELL:=as.factor(ELL)]
levels(Hawaii_Data_LONG_2023$ELL) <- c("ELL: No", "ELL: Yes")
Hawaii_Data_LONG_2023[,SpEd:=as.factor(SpEd)]
Hawaii_Data_LONG_2023[,Migrant:=as.factor(Migrant)]
Hawaii_Data_LONG_2023[,Scale_Score:=as.numeric(Scale_Score)]
Hawaii_Data_LONG_2023[,FSY:=as.factor(FSY)]
Hawaii_Data_LONG_2023[,ETHNICITY:=as.character(Fed7_Ethnic)]
Hawaii_Data_LONG_2023[DOE_Ethnic %in% c("Native Hawaiian", "Part-Hawaiian"), ETHNICITY:="Native Hawaiian"]
Hawaii_Data_LONG_2023[,ETHNICITY:=as.factor(ETHNICITY)]
levels(Hawaii_Data_LONG_2023$ETHNICITY)[4] <- "Hispanic or Latino"
Hawaii_Data_LONG_2023[District=="Charter", District:="Charter Schools"]
Hawaii_Data_LONG_2023[,Complex:=as.factor(Hawaii_Data_LONG_2023$Complex)]
levels(Hawaii_Data_LONG_2023$Complex) <- as.vector(sapply(levels(Hawaii_Data_LONG_2023$Complex), capwords))
levels(Hawaii_Data_LONG_2023$Complex)[c(21,24)] <- paste(levels(Hawaii_Data_LONG_2023$Complex)[c(21,24)], "Complex")
levels(Hawaii_Data_LONG_2023$Complex)[29] <- "McKinley Complex"
Hawaii_Data_LONG_2023[,Complex.Area:=as.factor(Complex.Area)]
Hawaii_Data_LONG_2023[,Sex:=as.factor(Sex)]
Hawaii_Data_LONG_2023[,ELL_STATUS_MULTILEVEL:=as.factor(ELL_STATUS_MULTILEVEL)]
Hawaii_Data_LONG_2023[,School_Admin_Rollup:=as.factor(School_Admin_Rollup)]
Hawaii_Data_LONG_2023[,District:=as.factor(District)]
Hawaii_Data_LONG_2023[,STATE_ENROLLMENT_STATUS:=as.factor(STATE_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2023[,SCHOOL_ENROLLMENT_STATUS:=as.factor(SCHOOL_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2023[,DISTRICT_ENROLLMENT_STATUS:=as.factor(DISTRICT_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2023[FSY=="Full School Year Status: No",DISTRICT_ENROLLMENT_STATUS:="Enrolled District: No"]
Hawaii_Data_LONG_2023[,COMPLEX_ENROLLMENT_STATUS:=as.factor(COMPLEX_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2023[FSY=="Full School Year Status: No",COMPLEX_ENROLLMENT_STATUS:="Enrolled Complex: No"]
Hawaii_Data_LONG_2023[,COMPLEX_AREA_ENROLLMENT_STATUS:=as.factor(COMPLEX_AREA_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2023[FSY=="Full School Year Status: No",COMPLEX_AREA_ENROLLMENT_STATUS:="Enrolled Complex Area: No"]
Hawaii_Data_LONG_2023[,FSY_SchCode:=as.integer(FSY_SchCode)]

Hawaii_Data_LONG_2023[,HIGH_NEED_STATUS_DEMOGRAPHIC:=
        factor(2, levels=1:2, labels=c("High Need Status: ELL, Special Education, or Disadvantaged Student", "High Need Status: Non-ELL, Non-Special Education, and Non-Disadvantaged Student"))]
Hawaii_Data_LONG_2023$HIGH_NEED_STATUS_DEMOGRAPHIC[Hawaii_Data_LONG_2023$Disadv=="Disadvantaged: Yes" | Hawaii_Data_LONG_2023$ELL=="ELL Status: Yes" | Hawaii_Data_LONG_2023$SpEd=="Special Education: Yes"] <- "High Need Status: ELL, Special Education, or Disadvantaged Student"

Hawaii_Data_LONG_2023[,SCHOOL_FSY_ENROLLMENT_STATUS:=factor(2, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))]
Hawaii_Data_LONG_2023$SCHOOL_FSY_ENROLLMENT_STATUS[Hawaii_Data_LONG_2023$SCHOOL_ENROLLMENT_STATUS=="Enrolled School: No" | Hawaii_Data_LONG_2023$FSY=="Full School Year Status: No"] <- "Enrolled School: No"

### Reorder variables
my.variable.order <- c("VALID_CASE", "Domain", "Year", "Gr", "IDNO", "LName", "FName", "SCode_Admin_Rollup", "School_Admin_Rollup", "FSY_SchCode", "EMH.Level", "DCode", "District", "CCode", "Complex",
	"CACode", "Complex.Area", "Sex", "ETHNICITY", "HIGH_NEED_STATUS_DEMOGRAPHIC", "DOE_Ethnic", "Fed7_Ethnic", "Fed5_Ethnic", "Disadv", "ELL", "ELL_STATUS_MULTILEVEL", "SpEd",
	"Migrant", "Scale_Score", "Proficiency_Level", "FSY", "SCHOOL_ENROLLMENT_STATUS", "DISTRICT_ENROLLMENT_STATUS", "COMPLEX_ENROLLMENT_STATUS", "COMPLEX_AREA_ENROLLMENT_STATUS",
	"STATE_ENROLLMENT_STATUS", "SCHOOL_FSY_ENROLLMENT_STATUS")
setcolorder(Hawaii_Data_LONG_2023, my.variable.order)

### Check for duplicates
setkey(Hawaii_Data_LONG_2023, VALID_CASE, Year, Domain, Gr, IDNO, Scale_Score)
setkey(Hawaii_Data_LONG_2023, VALID_CASE, Year, Domain, Gr, IDNO)
Hawaii_Data_LONG_2023[which(duplicated(Hawaii_Data_LONG_2023, by=key(Hawaii_Data_LONG_2023)))-1, VALID_CASE:="INVALID_CASE"]

### setkey
setkey(Hawaii_Data_LONG_2023, VALID_CASE, Year, Domain, Gr, IDNO)


### Save results
save(Hawaii_Data_LONG_2023, file="Data/Hawaii_Data_LONG_2023.Rdata")
