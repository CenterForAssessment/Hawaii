#+ include = FALSE, purl = FALSE
###########################################################################
###
###   R Syntax for construction of 2022 Hawaii LONG data file
###
###########################################################################

#' ## Data Preparation
#' 
#' The data preparation step involves taking data provided by the HIDOE and
#' producing a `.Rdata` file that will subsequently be analyzed using the `SGP`
#' software. This process is carried out annually as new data becomes available.
#' 
#' For the 2022 Hawai'i SBA data preparation and cleaning, we first modify
#' values of student demographic and enrollment status variables to match with
#' values and factor levels that have been used in previous years or as
#' required to conform to the `SGP` package conventions.
#' 
#' An auxiliary data set with information regarding the full school year
#' attendance for select students is then used to verify and modify (if necessary)
#' the enrollment status variables. This will ensure that any subsequent school,
#' district and complex growth and achievement aggregates that are produced
#' after the SGP calculations will contain the appropriate students. Note that
#' this does not impact which students will be included in the growth calculations.
#'
#' Finally, the 2022 SBA data was examined to identify invalid records. 
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
Hawaii_Data_LONG_2022 <- fread("Data/Base_Files/Hawaii_Data_LONG_2022.txt")
FSY_Update <- fread("Data/Base_Files/FSYFor297and568.csv")


### Tidy up data
setnames(Hawaii_Data_LONG_2022, c("Valid_Case", "grade", "lastName", "firstName", "EMH Level", "ELL Status", "Complex Area"),
    c("VALID_CASE", "Gr", "LName", "FName", "EMH.Level", "ELL_STATUS_MULTILEVEL", "Complex.Area"))
Hawaii_Data_LONG_2022[,VALID_CASE:="VALID_CASE"]
Hawaii_Data_LONG_2022[,Year:=as.character(Year)]
Hawaii_Data_LONG_2022[,IDNO:=as.character(IDNO)]
Hawaii_Data_LONG_2022[,Gr:=as.character(as.numeric(Gr))]
Hawaii_Data_LONG_2022[Gr %in% c("10"), VALID_CASE:="INVALID_CASE"]
Hawaii_Data_LONG_2022[,Fed7_Ethnic:=as.factor(Fed7_Ethnic)]
levels(Hawaii_Data_LONG_2022$Fed7_Ethnic)[3] <- "Black or African American"
Hawaii_Data_LONG_2022[,Fed5_Ethnic:=as.factor(Fed5_Ethnic)]
Hawaii_Data_LONG_2022[,Disadv:=as.factor(Disadv)]
levels(Hawaii_Data_LONG_2022$Disadv) <- c("Disadvantaged: No", "Disadvantaged: Yes")
Hawaii_Data_LONG_2022[,ELL:=as.factor(ELL)]
levels(Hawaii_Data_LONG_2022$ELL) <- c("ELL: No", "ELL: Yes")
Hawaii_Data_LONG_2022[,SpEd:=as.factor(SpEd)]
Hawaii_Data_LONG_2022[,Migrant:=as.factor(Migrant)]
Hawaii_Data_LONG_2022[,Scale_Score:=as.numeric(Scale_Score)]
Hawaii_Data_LONG_2022[,FSY:=as.factor(FSY)]
Hawaii_Data_LONG_2022[,ETHNICITY:=as.character(Fed7_Ethnic)]
Hawaii_Data_LONG_2022[DOE_Ethnic %in% c("Native Hawaiian", "Part-Hawaiian"), ETHNICITY:="Native Hawaiian"]
Hawaii_Data_LONG_2022[,ETHNICITY:=as.factor(ETHNICITY)]
levels(Hawaii_Data_LONG_2022$ETHNICITY)[4] <- "Hispanic or Latino"
Hawaii_Data_LONG_2022[District=="Charter", District:="Charter Schools"]
Hawaii_Data_LONG_2022[,Complex:=as.factor(Hawaii_Data_LONG_2022$Complex)]
levels(Hawaii_Data_LONG_2022$Complex) <- as.vector(sapply(levels(Hawaii_Data_LONG_2022$Complex), capwords))
levels(Hawaii_Data_LONG_2022$Complex)[c(21,24)] <- paste(levels(Hawaii_Data_LONG_2022$Complex)[c(21,24)], "Complex")
levels(Hawaii_Data_LONG_2022$Complex)[29] <- "McKinley Complex"
Hawaii_Data_LONG_2022[,Complex.Area:=as.factor(Complex.Area)]
Hawaii_Data_LONG_2022[,Sex:=as.factor(Sex)]
Hawaii_Data_LONG_2022[,ELL_STATUS_MULTILEVEL:=as.factor(ELL_STATUS_MULTILEVEL)]
Hawaii_Data_LONG_2022[,School_Admin_Rollup:=as.factor(School_Admin_Rollup)]
Hawaii_Data_LONG_2022[,District:=as.factor(District)]
Hawaii_Data_LONG_2022[,STATE_ENROLLMENT_STATUS:=as.factor(STATE_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2022[,SCHOOL_ENROLLMENT_STATUS:=as.factor(SCHOOL_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2022[,DISTRICT_ENROLLMENT_STATUS:=as.factor(DISTRICT_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2022[FSY=="Full School Year Status: No",DISTRICT_ENROLLMENT_STATUS:="Enrolled District: No"]
Hawaii_Data_LONG_2022[,COMPLEX_ENROLLMENT_STATUS:=as.factor(COMPLEX_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2022[FSY=="Full School Year Status: No",COMPLEX_ENROLLMENT_STATUS:="Enrolled Complex: No"]
Hawaii_Data_LONG_2022[,COMPLEX_AREA_ENROLLMENT_STATUS:=as.factor(COMPLEX_AREA_ENROLLMENT_STATUS)]
Hawaii_Data_LONG_2022[FSY=="Full School Year Status: No",COMPLEX_AREA_ENROLLMENT_STATUS:="Enrolled Complex Area: No"]
Hawaii_Data_LONG_2022[,FSY_SchCode:=as.integer(FSY_SchCode)]

Hawaii_Data_LONG_2022[,HIGH_NEED_STATUS_DEMOGRAPHIC:=
        factor(2, levels=1:2, labels=c("High Need Status: ELL, Special Education, or Disadvantaged Student", "High Need Status: Non-ELL, Non-Special Education, and Non-Disadvantaged Student"))]
Hawaii_Data_LONG_2022$HIGH_NEED_STATUS_DEMOGRAPHIC[Hawaii_Data_LONG_2022$Disadv=="Disadvantaged: Yes" | Hawaii_Data_LONG_2022$ELL=="ELL Status: Yes" | Hawaii_Data_LONG_2022$SpEd=="Special Education: Yes"] <- "High Need Status: ELL, Special Education, or Disadvantaged Student"

Hawaii_Data_LONG_2022[,SCHOOL_FSY_ENROLLMENT_STATUS:=factor(2, levels=1:2, labels=c("Enrolled School: No", "Enrolled School: Yes"))]
Hawaii_Data_LONG_2022$SCHOOL_FSY_ENROLLMENT_STATUS[Hawaii_Data_LONG_2022$SCHOOL_ENROLLMENT_STATUS=="Enrolled School: No" | Hawaii_Data_LONG_2022$FSY=="Full School Year Status: No"] <- "Enrolled School: No"

### Reorder variables
my.variable.order <- c("VALID_CASE", "Domain", "Year", "Gr", "IDNO", "LName", "FName", "SCode_Admin_Rollup", "School_Admin_Rollup", "FSY_SchCode", "EMH.Level", "DCode", "District", "CCode", "Complex",
    "CACode", "Complex.Area", "Sex", "ETHNICITY", "HIGH_NEED_STATUS_DEMOGRAPHIC", "DOE_Ethnic", "Fed7_Ethnic", "Fed5_Ethnic", "Disadv", "ELL", "ELL_STATUS_MULTILEVEL", "SpEd",
    "Migrant", "Scale_Score", "Proficiency_Level", "FSY", "SCHOOL_ENROLLMENT_STATUS", "DISTRICT_ENROLLMENT_STATUS", "COMPLEX_ENROLLMENT_STATUS", "COMPLEX_AREA_ENROLLMENT_STATUS",
    "STATE_ENROLLMENT_STATUS", "SCHOOL_FSY_ENROLLMENT_STATUS")
setcolorder(Hawaii_Data_LONG_2022, my.variable.order)

### Update FSY status
setnames(FSY_Update, c("IDNo", "Grade"), c("ID", "GRADE"))
FSY_Update[,ID:=as.character(ID)]
setkey(FSY_Update, ID)
Hawaii_Data_LONG_2022[IDNO %in% FSY_Update$ID, FSY:="Full School Year Status: Yes"]
Hawaii_Data_LONG_2022[IDNO %in% FSY_Update$ID, SCHOOL_ENROLLMENT_STATUS:="Enrolled School: Yes"]
Hawaii_Data_LONG_2022[IDNO %in% FSY_Update$ID, SCHOOL_FSY_ENROLLMENT_STATUS:="Enrolled School: Yes"]
Hawaii_Data_LONG_2022[IDNO %in% FSY_Update$ID, COMPLEX_ENROLLMENT_STATUS:="Enrolled Complex: Yes"]
Hawaii_Data_LONG_2022[IDNO %in% FSY_Update$ID, COMPLEX_AREA_ENROLLMENT_STATUS:="Enrolled Complex Area: Yes"]

###   MERGE IN STUDENTS WHO WERE ENROLLED BUT DIDN'T TEST
###   Done in November after analyses run - added to final datasets

require(Hmisc)
mdb_path <-
    paste0(
        "'", getwd(),
        "/Data/Base_Files/2022FinaltblAnalysisData-formattedforDamian.mdb'"
    )
mdb.get(mdb_path, tables = TRUE)
Hawaii_Enrollment_Data_2022 <-
    mdb.get(mdb_path, tables = "tblSBAStudents2022") |> as.data.table()

variables.to.keep <-
    c("IDNo", "SchCode", "LName", "Fname", "Grade", "Sex", "FederalEthCode",
      "Fed7", "DisadvantagedFlag", "SLEPFlag", "SPEDFlag", "MigrantFlag",
      "FSYFlag", "ParticipationSubjects", "MathSS", "ReadSS", "MathParD", "ELAParD"
    )
Hawaii_Enrollment_Data_2022 <-
    Hawaii_Enrollment_Data_2022[, variables.to.keep, with = FALSE]
setnames(
    Hawaii_Enrollment_Data_2022,
    c("IDNO", "SCode_Admin_Rollup", "LName", "FName", "Gr", "Sex", "Fed5_Ethnic",
      "Fed7_Ethnic", "Disadv", "ELL", "SpEd", "Migrant",
      "FSY", "ParticipationSubjects", "MathSS", "ReadSS", "MathParD", "ELAParD"
    )
)
Hawaii_Enrollment_Data_2022[, 
    SCHOOL_FSY_ENROLLMENT_STATUS := "Enrolled School: Yes"][,
    SCHOOL_ENROLLMENT_STATUS := "Enrolled School: Yes"
]

tmp.reading <-
    Hawaii_Enrollment_Data_2022[
        ParticipationSubjects %in% c("MR", "MRS", "R", "RS")][,
            c("MathSS", "MathParD") := NULL
        ][,
            Domain := "READING"
        ]
setnames(tmp.reading, c("ReadSS", "ELAParD"), c("Scale_Score", "ParD"))
tmp.math <-
    Hawaii_Enrollment_Data_2022[
        ParticipationSubjects %in% c("M", "MR", "MRS", "MS")][,
            c("ReadSS", "ELAParD") := NULL
        ][,
            Domain := "MATHEMATICS"
        ]
setnames(tmp.math, c("MathSS", "MathParD"), c("Scale_Score", "ParD"))

Hawaii_Missing_Data_2022 <- rbindlist(list(tmp.math, tmp.reading))
Hawaii_Missing_Data_2022 <-
    Hawaii_Missing_Data_2022[is.na(Scale_Score)][,
        ParticipationSubjects := NULL
    ][,
        VALID_CASE := "VALID_CASE"
    ]
Hawaii_Missing_Data_2022[
    ParD == 0,
    c("SCHOOL_FSY_ENROLLMENT_STATUS", "SCHOOL_ENROLLMENT_STATUS") :=
      "Enrolled School: No"
][, ParD := NULL]

tmp.lookup <-
    Hawaii_Data_LONG_2022[VALID_CASE == "VALID_CASE",
        c("VALID_CASE", "SCode_Admin_Rollup", "Gr", "EMH.Level",
          "DCode", "District", "CCode", "Complex", "CACode", "Complex.Area"
        )] |> unique(by = c("VALID_CASE", "SCode_Admin_Rollup", "Gr"))
Hawaii_Missing_Data_2022[, Gr := as.character(Gr)]
setkeyv(Hawaii_Missing_Data_2022, c("VALID_CASE", "SCode_Admin_Rollup", "Gr"))
setkeyv(tmp.lookup, c("VALID_CASE", "SCode_Admin_Rollup", "Gr"))
Hawaii_Missing_Data_2022 <- tmp.lookup[Hawaii_Missing_Data_2022]

setcolorder(
    Hawaii_Missing_Data_2022,
    match(
        names(Hawaii_Data_LONG_2022),
        names(Hawaii_Missing_Data_2022)
    )[!is.na(match(names(Hawaii_Data_LONG_2022), names(Hawaii_Missing_Data_2022)))]
)

Hawaii_Missing_Data_2022[,
    IDNO := as.character(IDNO)][,
    DCode := as.integer(DCode)][,
    CCode := as.integer(CCode)][,
    CACode := as.integer(CACode)][,
    Scale_Score := as.numeric(Scale_Score)][,
    Sex := as.factor(Sex)][,
    ELL := as.factor(ELL)][,
    SpEd := as.factor(SpEd)][,
    Disadv := as.factor(Disadv)][,
    Migrant := as.factor(Migrant)][,
    Fed5_Ethnic := as.factor(Fed5_Ethnic)][,
    Fed7_Ethnic := as.factor(Fed7_Ethnic)][,
    FSY := as.factor(FSY)][,
    SCHOOL_ENROLLMENT_STATUS := as.factor(SCHOOL_ENROLLMENT_STATUS)][,
    SCHOOL_FSY_ENROLLMENT_STATUS := as.factor(SCHOOL_FSY_ENROLLMENT_STATUS)
]
levels(Hawaii_Missing_Data_2022$Sex) <-
    c("Female", "Male")
levels(Hawaii_Missing_Data_2022$ELL) <-
    c("ELL: No", "ELL: Yes")
levels(Hawaii_Missing_Data_2022$SpEd) <-
    c("Special Education: No", "Special Education: Yes")
levels(Hawaii_Missing_Data_2022$Disadv) <-
    c("Disadvantaged: No", "Disadvantaged: Yes")
levels(Hawaii_Missing_Data_2022$Migrant) <-
    c("Migrant: No", "Migrant: Yes")
levels(Hawaii_Missing_Data_2022$Fed7_Ethnic) <-
    c("American Indian or Alaska Native", "Asian", "Black or African American",
      "Hispanic", "Two or more races", "Pacific Islander", "White"
    )
levels(Hawaii_Missing_Data_2022$Fed5_Ethnic) <-
    c("American Indian or Alaska Native", "Asian/Pacific Islander",
      "Black or African American", "Hispanic or Latino", "White"
    )
levels(Hawaii_Missing_Data_2022$FSY) <-
    c("Full School Year Status: No", "Full School Year Status: Yes")


### rbind results
Hawaii_Data_LONG_2022 <-
    rbindlist(
        list(
            Hawaii_Data_LONG_2022,
            Hawaii_Missing_Data_2022
        ),
        fill = TRUE
    )
Hawaii_Data_LONG_2022[is.na(Scale_Score), VALID_CASE := "INVALID_CASE"]

###   Fix/output 2022 results files
setNamesSGP(Hawaii_Missing_Data_2022)
Hawaii_Missing_Data_2022[,
    VALID_CASE := "INVALID_CASE"][,
    YEAR := "2022"
]

load("Data/Hawaii_SGP.Rdata")

Hawaii_SGP@Data <-
    rbindlist(
        list(
            Hawaii_SGP@Data,
            Hawaii_Missing_Data_2022
        ),
        fill = TRUE
    )

outputSGP(Hawaii_SGP)

save(Hawaii_SGP, file = "Data/Hawaii_SGP.Rdata")

### Check for duplicates
setkey(Hawaii_Data_LONG_2022, VALID_CASE, Year, Domain, Gr, IDNO, Scale_Score)
setkey(Hawaii_Data_LONG_2022, VALID_CASE, Year, Domain, Gr, IDNO)
Hawaii_Data_LONG_2022[which(duplicated(Hawaii_Data_LONG_2022, by=key(Hawaii_Data_LONG_2022)))-1, VALID_CASE:="INVALID_CASE"]

### setkey
setkey(Hawaii_Data_LONG_2022, VALID_CASE, Year, Domain, Gr, IDNO)

### Save results
save(Hawaii_Data_LONG_2022, file="Data/Hawaii_Data_LONG_2022.Rdata")
