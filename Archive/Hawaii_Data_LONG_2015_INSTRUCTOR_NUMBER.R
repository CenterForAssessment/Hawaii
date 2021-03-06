################################################################################
###
### Syntax for create instructor number file for 2015
###
################################################################################

### Load SGP Package

require(SGP)
require(data.table)


### Load data

Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER <- fread("Data/Base_Files/BFK_Cleaned_Spring_2015.txt", colClasses=rep("character", 13))


### Remove duplicates

setkeyv(Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER, names(Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER))
Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER <- Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER[!duplicated(Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER)]


### Extract relevant variables

variables.to.use <- c("StaffUniqueID", "StaffLastName", "StaffFirstName", "SchoolName", "SchoolCode_[NEW]", "SubjectName", "StateStudentID", "rounded_terms")
Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER <- Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER[,variables.to.use, with=FALSE]



### Tidy up data

setnames(Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER,
	names(Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER),
	c("INSTRUCTOR_NUMBER", "INSTRUCTOR_LAST_NAME", "INSTRUCTOR_FIRST_NAME", "SCHOOL_NAME_INSTRUCTOR", "SCHOOL_NUMBER_INSTRUCTOR", "CONTENT_AREA", "ID",  "TERMS"))
Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER$YEAR <- "2015"
setcolorder(Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER,
		c("ID","CONTENT_AREA", "YEAR", "INSTRUCTOR_NUMBER", "INSTRUCTOR_LAST_NAME", "INSTRUCTOR_FIRST_NAME", "SCHOOL_NUMBER_INSTRUCTOR", "SCHOOL_NAME_INSTRUCTOR",
		 	"TERMS" ))

Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER[CONTENT_AREA=="Math", CONTENT_AREA:="MATHEMATICS"]
Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER[CONTENT_AREA=="ELA", CONTENT_AREA:="READING"]
Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER[, INSTRUCTOR_ENROLLMENT_STATUS :=factor(1, levels=0:1, labels=c("Enrolled Instructor: No", "Enrolled Instructor: Yes"))]
Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER[,TERMS:=as.numeric(TERMS)]
Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER[,INSTRUCTOR_LAST_NAME:=as.factor(INSTRUCTOR_LAST_NAME)]
Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER[,INSTRUCTOR_FIRST_NAME:=as.factor(INSTRUCTOR_FIRST_NAME)]
Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER[,SCHOOL_NUMBER_INSTRUCTOR:=as.integer(SCHOOL_NUMBER_INSTRUCTOR)]
Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER[,SCHOOL_NAME_INSTRUCTOR:=as.factor(SCHOOL_NAME_INSTRUCTOR)]
Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER[,VALID_CASE:="VALID_CASE"]

### Create TERMS variable from sum of TERMS

Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER <- Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER[,TERMS:=sum(TERMS, na.rm=TRUE), keyby=list(ID, CONTENT_AREA, INSTRUCTOR_NUMBER)]
Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER <- Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER[!duplicated(Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER)]


### Create Weight Variable

Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER[,INSTRUCTOR_WEIGHT:=round(TERMS/sum(TERMS, na.rm=TRUE), digits=2), by=list(ID, CONTENT_AREA)]


### NULL out extraneous variables

Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER[,TERMS:=NULL]


### Set column order

tmp.column.order <- c('ID', 'CONTENT_AREA', 'YEAR', 'INSTRUCTOR_NUMBER', 'INSTRUCTOR_LAST_NAME', 'INSTRUCTOR_FIRST_NAME',
	'SCHOOL_NUMBER_INSTRUCTOR', 'SCHOOL_NAME_INSTRUCTOR', 'INSTRUCTOR_WEIGHT', 'INSTRUCTOR_ENROLLMENT_STATUS', 'VALID_CASE')
setcolorder(Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER, tmp.column.order)
setkeyv(Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER, c("ID", "CONTENT_AREA", "YEAR"))


### Save results

save(Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER, file="Data/Hawaii_Data_LONG_2015_INSTRUCTOR_NUMBER.Rdata")
