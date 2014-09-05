################################################################################
###
### Syntax for create instructor number file for 2014
###
################################################################################

### Load SGP Package

require(SGP)
require(data.table)


###########################################################################
###
### Create teacher linkage file
###
###########################################################################

### Load data

Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER <- read.delim("Data/Base_Files/BFK_Cleaned_Spring_2014.txt")


### Extract relevant variables

variables.to.use <- c("StaffUniqueID", "StaffLastName", "StaffFirstName", "SchoolCode", "SchoolName", "SubjectName", "RosterStatus", "StateStudentID", "StudentGradeLevel", "Terms")
Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER <- as.data.table(Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER[,variables.to.use])


### Tidy up data 

setnames(Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER, 
	names(Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER), 
	c("INSTRUCTOR_NUMBER", "INSTRUCTOR_LAST_NAME", "INSTRUCTOR_FIRST_NAME", "SCHOOL_NUMBER_INSTRUCTOR", "SCHOOL_NAME_INSTRUCTOR", "CONTENT_AREA", "ROSTER_STATUS", "ID", "GRADE", "TERMS"))
Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER$YEAR <- "2014"
setcolorder(Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER, c(8,6,11,1,2,3,4,5,7,9,10))

Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER$ID <- as.character(Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER$ID)
Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER$CONTENT_AREA <- as.character(Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER$CONTENT_AREA)
Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER$CONTENT_AREA[Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER$CONTENT_AREA=="Math"] <- "MATHEMATICS"
Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER$CONTENT_AREA[Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER$CONTENT_AREA=="Language Arts"] <- "READING"
Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER$INSTRUCTOR_NUMBER <- as.character(Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER$INSTRUCTOR_NUMBER)
Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER$INSTRUCTOR_ENROLLMENT_STATUS <- factor(1, levels=0:1, labels=c("Enrolled Instructor: No", "Enrolled Instructor: Yes"))

Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER <- subset(Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER, ROSTER_STATUS %in% c("Submitted", "Approved"))

setkey(Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER, ID, CONTENT_AREA, INSTRUCTOR_NUMBER)
Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER <- Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER[!duplicated(Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER)]


### Create Weight Variable

Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER[,INSTRUCTOR_WEIGHT:=round(TERMS/sum(TERMS, na.rm=TRUE), digits=2), by=list(ID, CONTENT_AREA)]

#########
###
###		From the Hawaii SGP training 2/19/2014, questions about what Josh did to create the variables 
###		that were subsequently used to compute INSTRUCTOR_WEIGHT.
###		How was “Sum of Days” field created in BFK_Cleaned_Spring_2014.txt ?  HI DOE will need to figure out for 2014
###		Terms = Sum of Days / 40  (must have been done in Excel not R.  When Sums.of.Days == 20 & 100, TERMS = 1 and 1.5, but R rounds those *.5 down to 0 and 1)
###
###		Hawaii_2014_INSTRUCTOR_NUMBER <- data.table(read.delim("Data/Base_Files/BFK_Cleaned_Spring_2014.txt"))
###		tmp.tbl <- Hawaii_2014_INSTRUCTOR_NUMBER[, as.list(summary(Sum.of.Days)), by=Terms]
###		setkeyv(tmp.tbl, 'Terms')
###		tmp.tbl
###
#########

### NULL out extraneous variables

Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER$GRADE <- NULL
Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER$TERMS <- Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER$ROSTER_STATUS <- NULL


### Set column order

tmp.column.order <- c('ID', 'CONTENT_AREA', 'YEAR', 'INSTRUCTOR_NUMBER', 'INSTRUCTOR_LAST_NAME', 'INSTRUCTOR_FIRST_NAME', 
	'SCHOOL_NUMBER_INSTRUCTOR', 'SCHOOL_NAME_INSTRUCTOR', 'INSTRUCTOR_WEIGHT', 'INSTRUCTOR_ENROLLMENT_STATUS')
setcolorder(Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER, tmp.column.order)
setkeyv(Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER, c("ID", "CONTENT_AREA", "YEAR"))


### Save results

save(Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER, file="Data/Hawaii_Data_LONG_2014_INSTRUCTOR_NUMBER.Rdata")
