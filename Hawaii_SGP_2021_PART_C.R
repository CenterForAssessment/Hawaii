################################################################################
###                                                                          ###
###           SGP LAGGED projections for skip year SGP analyses for 2021     ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/Hawaii_SGP.Rdata"))

###   Load configurations
source("SGP_CONFIG/2021/PART_C/READING.R")
source("SGP_CONFIG/2021/PART_C/MATHEMATICS.R")

HI_CONFIG <- c(READING_2021.config, MATHEMATICS_2021.config)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

###   Setup SGPstateData with baseline coefficient matrices grade specific projection sequences

###   Add Baseline matrices to SGPstateData and update SGPstateData
SGPstateData <- addBaselineMatrices("HI", "2021")
SGPstateData[["HI"]][["Growth"]][["System_Type"]] <- "Baseline Referenced"

#  Establish required meta-data for LAGGED projection sequences
SGPstateData[["HI"]][["SGP_Configuration"]][["grade.projection.sequence"]] <- list(
    READING_GRADE_3=c(3, 4, 5, 6, 7, 8),
    READING_GRADE_4=c(3, 4, 5, 6, 7, 8),
    READING_GRADE_5=c(3, 5, 6, 7, 8),
    READING_GRADE_6=c(3, 4, 6, 7, 8),
    READING_GRADE_7=c(3, 4, 5, 7, 8),
    READING_GRADE_8=c(3, 4, 5, 6, 8),
    MATHEMATICS_GRADE_3=c(3, 4, 5, 6, 7, 8),
    MATHEMATICS_GRADE_4=c(3, 4, 5, 6, 7, 8),
    MATHEMATICS_GRADE_5=c(3, 5, 6, 7, 8),
    MATHEMATICS_GRADE_6=c(3, 4, 6, 7, 8),
    MATHEMATICS_GRADE_7=c(3, 4, 5, 7, 8),
    MATHEMATICS_GRADE_8=c(3, 4, 5, 6, 8))
SGPstateData[["HI"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <- list(
    READING_GRADE_3=rep("READING", 6),
    READING_GRADE_4=rep("READING", 6),
    READING_GRADE_5=rep("READING", 5),
    READING_GRADE_6=rep("READING", 5),
    READING_GRADE_7=rep("READING", 5),
    READING_GRADE_8=rep("READING", 5),
    MATHEMATICS_GRADE_3=rep("MATHEMATICS", 6),
    MATHEMATICS_GRADE_4=rep("MATHEMATICS", 6),
    MATHEMATICS_GRADE_5=rep("MATHEMATICS", 5),
    MATHEMATICS_GRADE_6=rep("MATHEMATICS", 5),
    MATHEMATICS_GRADE_7=rep("MATHEMATICS", 5),
    MATHEMATICS_GRADE_8=rep("MATHEMATICS", 5))
SGPstateData[["HI"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <- list(
    READING_GRADE_3=3,
    READING_GRADE_4=3,
    READING_GRADE_5=3,
    READING_GRADE_6=3,
    READING_GRADE_7=3,
    READING_GRADE_8=3,
    MATHEMATICS_GRADE_3=3,
    MATHEMATICS_GRADE_4=3,
    MATHEMATICS_GRADE_5=3,
    MATHEMATICS_GRADE_6=3,
    MATHEMATICS_GRADE_7=3,
    MATHEMATICS_GRADE_8=3)


### Run analysis

Hawaii_SGP <- abcSGP(
        Hawaii_SGP,
        steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config=HI_CONFIG,
        sgp.percentiles=FALSE,
        sgp.projections=FALSE,
        sgp.projections.lagged=FALSE,
        sgp.percentiles.baseline=FALSE,
        sgp.projections.baseline=FALSE,
        sgp.projections.lagged.baseline=TRUE,
        sgp.target.scale.scores=TRUE,
        outputSGP.directory=output.directory,
        parallel.config=parallel.config
)


###  Save results
save(Hawaii_SGP, "Data/Hawaii_SGP.Rdata"))
