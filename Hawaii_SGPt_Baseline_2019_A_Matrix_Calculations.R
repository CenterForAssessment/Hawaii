################################################################################
###                                                                          ###
###       Hawaii Time Dependent SGP Analyses -- Create Baseline Matrices     ###
###                                                                          ###
################################################################################

### Load necessary packages
require(SGP)
require(data.table)
require(cfaTools)
#debug(studentGrowthPercentiles)

###   Load the results data from the base file with time dependent data
load("Data/Base_Files/Hawaii_Data_LONG_2015_2025_TIME_DEPENDENT.Rdata")

###   Create a smaller subset of the LONG data to work with.
Hawaii_Baseline_Data_TIME_DEPENDENT <- data.table::data.table(Hawaii_Data_LONG_2015_2025_TIME_DEPENDENT[Year >= 2015 & Year <= 2019 & !is.na(TStartDt) & !is.na(TEndDt) & TEndDt > TStartDt & grade %in% c("3", "4", "5", "6", "7", "8", "11"),
	c("IDNO", "Domain", "Year", "grade", "Scale_Score", "Proficiency_Level", "Valid_Case", "TStartDt", "TEndDt"),])
setnames(Hawaii_Baseline_Data_TIME_DEPENDENT, c("IDNO", "Domain", "Year", "grade", "Scale_Score", "Proficiency_Level", "Valid_Case", "TStartDt", "TEndDt"), c("ID", "CONTENT_AREA", "YEAR", "GRADE", "SCALE_SCORE", "ACHIEVEMENT_LEVEL", "VALID_CASE", "TStartDt", "TEndDt"))

### Tidy up data
Hawaii_Baseline_Data_TIME_DEPENDENT[,ID:=as.character(ID)]
Hawaii_Baseline_Data_TIME_DEPENDENT[,YEAR:=as.character(YEAR)]
Hawaii_Baseline_Data_TIME_DEPENDENT[,GRADE:=as.character(GRADE)]
Hawaii_Baseline_Data_TIME_DEPENDENT[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]
Hawaii_Baseline_Data_TIME_DEPENDENT[,ACHIEVEMENT_LEVEL:=as.character(ACHIEVEMENT_LEVEL)]
Hawaii_Baseline_Data_TIME_DEPENDENT[,VALID_CASE:=as.character(VALID_CASE)]

### Convert TStartDt and TEndDt to create date and time variables
### NOTE: Some values of TStartDt and TEndDt are missing (NA) or are set to 1900-01-01
###       for data 2019 and prior. Only create date/time variables when valid.
Hawaii_Baseline_Data_TIME_DEPENDENT[!is.na(TStartDt) & !is.na(TEndDt) & TEndDt > TStartDt, ':='(
    DATE_START = as.IDate(TStartDt),    # Test start date
    DATE_END = as.IDate(TEndDt),        # Test end date
    TIME_START = as.ITime(TStartDt),    # Test start time
    TIME_END = as.ITime(TEndDt)         # Test end time
)]

Hawaii_Baseline_Data_TIME_DEPENDENT[,DATE := DATE_END]

### Calculate time span within testing year (how long the test window was open)
Hawaii_Baseline_Data_TIME_DEPENDENT[, DATE_SPAN_WITHIN_YEAR := DATE_END - DATE_START]

### Create lagged date variables using cfaTools::getShiftedValues()
### This creates DATE_LAG_1 (previous year's date) for each student by domain
Hawaii_Baseline_Data_TIME_DEPENDENT <- getShiftedValues(
    Hawaii_Baseline_Data_TIME_DEPENDENT,
    shift_group = c("ID", "CONTENT_AREA"),   # Group by student and subject
    shift_period = "YEAR",                # Shift by year
    shift_variable = "DATE"               # Variable to shift
)

### Create DATE_LAG_3 (date from 3 years prior) for grade 11 analyses
Hawaii_Baseline_Data_TIME_DEPENDENT <- getShiftedValues(
    Hawaii_Baseline_Data_TIME_DEPENDENT,
    shift_group = c("ID", "CONTENT_AREA"),
    shift_period = "YEAR",
    shift_variable = "DATE",
    shift_amount = 3L                     # Look back 3 years
)

### Calculate DATE_SPAN_SGPt: Time elapsed between assessments
### This is THE CRITICAL VARIABLE for time-dependent SGP calculations
### - Grades 3-8: Use 1-year lag (consecutive years)
### - Grade 11: Use 3-year lag (accounts for testing schedule)
Hawaii_Baseline_Data_TIME_DEPENDENT[GRADE %in% c("3", "4", "5", "6", "7", "8"),
                            DATE_SPAN_SGPt := DATE - DATE_LAG_1]
Hawaii_Baseline_Data_TIME_DEPENDENT[GRADE == "11",
                            DATE_SPAN_SGPt := DATE - DATE_LAG_3]

### Remove temporary lag variables
Hawaii_Baseline_Data_TIME_DEPENDENT[, c("DATE_LAG_1", "DATE_LAG_3") := NULL]

### Set all VALID_CASE values to "VALID_CASE"
Hawaii_Baseline_Data_TIME_DEPENDENT[, VALID_CASE := "VALID_CASE"]

### Set data.table key for efficient operations
### Ordering: VALID_CASE, Year, Domain (subject), IDNO (student)
setkey(Hawaii_Baseline_Data_TIME_DEPENDENT, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)

###   Read in Baseline SGP Configuration Scripts and Combine
source("SGP_CONFIG/2019/BASELINE/Matrices/SGPt/READING.R")
source("SGP_CONFIG/2019/BASELINE/Matrices/SGPt/MATHEMATICS.R")

HI_BASELINE_CONFIG <- c(
	READING_2019.config,
	MATHEMATICS_2019.config
)

###   Run SGPt analyses via abcSGP
Hawaii_SGP <- abcSGP(
        sgp_object = Hawaii_Baseline_Data_TIME_DEPENDENT,   # Input data (2015-2019)
        steps = c("prepareSGP",                             # Prepare data structure
                  "analyzeSGP",                             # Run quantile regression models
                  "combineSGP"),                             # Merge results back to data
#                  "outputSGP"),                             # Export results
        sgp.config = HI_BASELINE_CONFIG,                             # Use configurations for Reading & Math
        sgp.percentiles = TRUE,                             # Calculate SGPt percentiles
        sgp.projections = FALSE,                            # Disable projections
        sgp.projections.lagged = FALSE,                     # Disable lagged projections
        sgp.percentiles.baseline = FALSE,                   # Disable baseline percentiles
        sgp.projections.baseline = FALSE,                   # Disable baseline projections
        sgp.projections.lagged.baseline = FALSE,            # Disable baseline lagged projections
        save.intermediate.results = FALSE,                  # Don't save intermediate files
        SGPt = TRUE,                                        # ENABLE TIME-DEPENDENT SGP
#        outputSGP.output.type = "LONG_FINAL_YEAR_Data",    # Output only 2022 data
#        outputSGP.directory = "Data/2019",                  # Save results to Data/2019/
        parallel.config = list(BACKEND="PARALLEL", WORKERS=list(TAUS=4))                   # Parallel processing config
)

###   Create baseline matrices
### Utility functions

convertToBaseline <- function(baseline_matrices) {
    tmp.list <- list()
    if (is.null(baseline_matrices)) {
        return(NULL)
    } else {
        for (i in names(baseline_matrices)) {
            for (j in seq_along(baseline_matrices[[i]])) {
                baseline_matrices[[i]][[j]]@Time <- list(rep("BASELINE", length(unlist(baseline_matrices[[i]][[j]]@Time))))
            }
            names(baseline_matrices[[i]]) <- sub("[.][1234]_", "_", names(baseline_matrices[[i]]))
        }

        tmp.content_areas <- unique(sapply(strsplit(names(baseline_matrices), "[.]"), '[', 1))
        for (i in tmp.content_areas) {
            tmp.list[[paste(i, "BASELINE", sep=".")]] <- unlist(baseline_matrices[grep(i, names(baseline_matrices))], recursive=FALSE)
        }
        return(tmp.list)
    }
}

### Create list of matrices
Hawaii_SGPt_Baseline_Matrices <- convertToBaseline(Hawaii_SGP@SGP$Coefficient_Matrices)

### Save matrices
save(Hawaii_SGPt_Baseline_Matrices, file="Data/Hawaii_SGPt_Baseline_Matrices_2019.Rdata")