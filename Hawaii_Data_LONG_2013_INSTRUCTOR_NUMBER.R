################################################################################
###
### Syntax for create instructor number file for 2013
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

Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER <- read.delim("/Users/damian/Documents/Github/Hawaii/Data/Base_Files/BFK_Cleaned_Spring_2013.txt")


### Extract relevant variables

Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER <- as.data.table(Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER[,c(1,2,3,5,7,9,10,14,18,20)])


### Tidy up data 

setnames(Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER, names(Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER), c("INSTRUCTOR_NUMBER", "INSTRUCTOR_LAST_NAME", "INSTRUCTOR_FIRST_NAME", "SCHOOL_NUMBER", "SCHOOL_NAME", "CONTENT_AREA",
"ROSTER_STATUS", "ID", "GRADE", "TERMS"))
Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER$YEAR <- "2013"
setcolorder(Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER, c(8,6,11,1,2,3,4,5,7,9,10))

Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER$ID <- as.character(Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER$ID)
Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER$CONTENT_AREA <- as.character(Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER$CONTENT_AREA)
Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER$CONTENT_AREA[Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER$CONTENT_AREA=="Math"] <- "MATHEMATICS"
Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER$CONTENT_AREA[Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER$CONTENT_AREA=="Language Arts"] <- "READING"
Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER$INSTRUCTOR_NUMBER <- as.character(Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER$INSTRUCTOR_NUMBER)
Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER$INSTRUCTOR_ENROLLMENT_STATUS <- factor(1, levels=0:1, labels=c("Enrolled Instructor: No", "Enrolled Instructor: Yes"))

Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER <- subset(Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER, ROSTER_STATUS %in% c("Submitted", "Approved"))

setkey(Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER, ID, CONTENT_AREA, INSTRUCTOR_NUMBER)
Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER <- Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER[!duplicated(Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER)]


### Create Weight Variable

Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER[,INSTRUCTOR_WEIGHT:=round(TERMS/sum(TERMS, na.rm=TRUE), digits=2), by=list(ID, CONTENT_AREA)]


### NULL out extraneous variables

Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER$SCHOOL_NUMBER <- Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER$SCHOOL_NAME <- Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER$GRADE <- NULL
Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER$TERMS <- Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER$ROSTER_STATUS <- NULL


### Set column order

setcolorder(Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER, c(1:6,8,7))
setkeyv(Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER, c("ID", "CONTENT_AREA", "YEAR"))


### Save results

save(Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER, file="Data/Hawaii_Data_LONG_2013_INSTRUCTOR_NUMBER.Rdata")


