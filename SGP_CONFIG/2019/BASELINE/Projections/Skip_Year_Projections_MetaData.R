################################################################################
###                                                                          ###
###       SGPstateData grade specific (skip-year) projection sequences       ###
###                                                                          ###
################################################################################

###  Only want 1 year projections for 2021 "Fair Trend" metric
SGPstateData[["HI"]][["SGP_Configuration"]][['sgp.projections.max.forward.progression.years']] <- 1
SGPstateData[["HI"]][['SGP_Configuration']][['max.sgp.target.years.forward']] <- 1

###   Set Skip_Year_Projections to TRUE (non-NULL) to allow for skip year
SGPstateData[["HI"]][["SGP_Configuration"]][["Skip_Year_Projections"]] <- TRUE

###   Establish required meta-data for STRAIGHT projection sequences
SGPstateData[["HI"]][["SGP_Configuration"]][["grade.projection.sequence"]] <- list(
    READING_GRADE_3 = c(3, 5),
    READING_GRADE_4 = c(3, 4, 6),
    READING_GRADE_5 = c(3, 4, 5, 7),
    READING_GRADE_6 = c(3, 4, 5, 6, 8),
    MATHEMATICS_GRADE_3 = c(3, 5),
    MATHEMATICS_GRADE_4 = c(3, 4, 6),
    MATHEMATICS_GRADE_5 = c(3, 4, 5, 7),
    MATHEMATICS_GRADE_6 = c(3, 4, 5, 6, 8))
SGPstateData[["HI"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <- list(
    READING_GRADE_3 = rep("READING", 2),
    READING_GRADE_4 = rep("READING", 3),
    READING_GRADE_5 = rep("READING", 4),
    READING_GRADE_6 = rep("READING", 5),
    MATHEMATICS_GRADE_3 = rep("MATHEMATICS", 2),
    MATHEMATICS_GRADE_4 = rep("MATHEMATICS", 3),
    MATHEMATICS_GRADE_5 = rep("MATHEMATICS", 4),
    MATHEMATICS_GRADE_6 = rep("MATHEMATICS", 5))
SGPstateData[["HI"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <- list(
    READING_GRADE_3 = 1,
    READING_GRADE_4 = 1,
    READING_GRADE_5 = 1,
    READING_GRADE_6 = 1,
    MATHEMATICS_GRADE_3 = 1,
    MATHEMATICS_GRADE_4 = 1,
    MATHEMATICS_GRADE_5 = 1,
    MATHEMATICS_GRADE_6 = 1)
