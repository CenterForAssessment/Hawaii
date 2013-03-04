###########################################################################
###
### Syntax for construction of Hawaii LONG data file
###
###########################################################################

### Load SGP Package

require(SGP)

### Load tab delimited data

Mathematics_2007 <- read.delim("Data/Base_Files/tbl03 HSAP 2007 Mathematics.txt", header=TRUE)
Mathematics_2008 <- read.delim("Data/Base_Files/tbl03 HSAP 2008 Mathematics.txt", header=TRUE)
Mathematics_2009 <- read.delim("Data/Base_Files/tbl03 HSAP 2009 Mathematics.txt", header=TRUE)
Mathematics_2010 <- read.delim("Data/Base_Files/tbl03 HSAP 2010 Mathematics.txt", header=TRUE)
Mathematics_2011 <- read.delim("Data/Base_Files/tbl03 HSAP 2011 Mathematics.txt", header=TRUE)
Mathematics_2012 <- read.delim("Data/Base_Files/tbl03 HSAP 2012 Mathematics.txt", header=TRUE)
Reading_2007 <- read.delim("Data/Base_Files/tbl03 HSAP 2007 Reading.txt", header=TRUE)
Reading_2008 <- read.delim("Data/Base_Files/tbl03 HSAP 2008 Reading.txt", header=TRUE)
Reading_2009 <- read.delim("Data/Base_Files/tbl03 HSAP 2009 Reading.txt", header=TRUE)
Reading_2010 <- read.delim("Data/Base_Files/tbl03 HSAP 2010 Reading.txt", header=TRUE)
Reading_2011 <- read.delim("Data/Base_Files/tbl03 HSAP 2011 Reading.txt", header=TRUE)
Reading_2012 <- read.delim("Data/Base_Files/tbl03 HSAP 2012 Reading.txt", header=TRUE)


### rbind all the data.frames

Hawaii_Data_LONG <- rbind(Mathematics_2007, Mathematics_2008, Mathematics_2009, Mathematics_2010, Mathematics_2011, Mathematics_2012,
			Reading_2007, Reading_2008, Reading_2009, Reading_2010, Reading_2011, Reading_2012)


### Tidy up data

names(Hawaii_Data_LONG)[which(names(Hawaii_Data_LONG)=="SC")] <- "SCode"

Hawaii_Data_LONG$IDNO <- as.character(Hawaii_Data_LONG$IDNO)

levels(Hawaii_Data_LONG$LName) <- sapply(levels(Hawaii_Data_LONG$LName), capwords)
levels(Hawaii_Data_LONG$FName) <- sapply(levels(Hawaii_Data_LONG$FName), capwords)

levels(Hawaii_Data_LONG$Domain) <- c("MATHEMATICS", "READING")
Hawaii_Data_LONG$Domain <- as.character(Hawaii_Data_LONG$Domain)

Hawaii_Data_LONG$Scale_Score <- as.numeric(Hawaii_Data_LONG$Scale_Score)

Hawaii_Data_LONG$Proficiency_Level <- factor(Hawaii_Data_LONG$Proficiency_Level, levels=1:4, labels=c("Well Below Proficiency", "Approaches Proficiency", "Meets Proficiency", "Exceeds Proficiency"))

Hawaii_Data_LONG$Type <- factor(Hawaii_Data_LONG$Type, levels=1:6, labels=c("Elementary", "Elementary-Middle", "Elementary-Middle-High", "Middle", "Middle-High", "High"))

Hawaii_Data_LONG$EthCode <- NULL
Hawaii_Data_LONG$Fed5_Code <- NULL
Hawaii_Data_LONG$Fed7_Code <- NULL

Hawaii_Data_LONG$Disadv <- factor(Hawaii_Data_LONG$Disadv, levels=0:1, labels=c("Disadvantaged: No", "Disadvantaged: Yes"))

Hawaii_Data_LONG$ELL <- factor(Hawaii_Data_LONG$ELL, levels=0:1, labels=c("ELL: No", "ELL: Yes"))

Hawaii_Data_LONG$SpEd <- factor(Hawaii_Data_LONG$SpEd, levels=0:1, labels=c("Special Education: No", "Special Education: Yes"))

levels(Hawaii_Data_LONG$Sex) <- c("Female", "Male")

Hawaii_Data_LONG$Migrant <- factor(Hawaii_Data_LONG$Migrant, levels=0:1, labels=c("Migrant: No", "Migrant: Yes"))

Hawaii_Data_LONG$FSY <- factor(Hawaii_Data_LONG$FSY, levels=0:1, labels=c("Full School Year Status: No", "Full School Year Status: Yes"))

Hawaii_Data_LONG$SCHOOL_ENROLLMENT_STATUS <- factor(1, levels=0:1, c("Enrolled School: No", "Enrolled School: Yes"))
Hawaii_Data_LONG$SCHOOL_ENROLLMENT_STATUS[Hawaii_Data_LONG$FSY=="Full School Year Status: No"] <- "Enrolled School: No"

Hawaii_Data_LONG$DISTRICT_ENROLLMENT_STATUS <- factor(1, levels=0:1, c("Enrolled District: No", "Enrolled District: Yes"))
Hawaii_Data_LONG$COMPLEX_ENROLLMENT_STATUS <- factor(1, levels=0:1, c("Enrolled Complex: No", "Enrolled Complex: Yes"))
Hawaii_Data_LONG$COMPLEX_AREA_ENROLLMENT_STATUS <- factor(1, levels=0:1, c("Enrolled Complex Area: No", "Enrolled Complex Area: Yes"))
Hawaii_Data_LONG$STATE_ENROLLMENT_STATUS <- factor(1, levels=0:1, c("Enrolled State: No", "Enrolled State: Yes"))


### Invalidate Scores

Hawaii_Data_LONG$VALID_CASE <- "VALID_CASE"
Hawaii_Data_LONG$VALID_CASE[Hawaii_Data_LONG$Source %in% c("HLIP", "HSAA", "HAPA", "Linapuni")] <- "INVALID_CASE"


### Save results

save(Hawaii_Data_LONG, file="Data/Hawaii_Data_LONG.Rdata")
