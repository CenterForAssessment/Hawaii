################################################################################
###                                                                          ###
###     Configurations for STRAIGHT (skip-year) Math projections in 2019     ###
###                                                                          ###
################################################################################

READING_2019.config <- list(
    READING.2019 = list(
        sgp.content.areas=c("READING", "READING"),
        sgp.baseline.content.areas=c("READING", "READING"),
        sgp.panel.years=c("2017", "2019"),
        sgp.baseline.panel.years=c("2017", "2019"),
        sgp.grade.sequences=list(c("3", "5")),
        sgp.baseline.grade.sequences=list(c("3", "5")),
        sgp.projection.baseline.content.areas=c("READING"),
        sgp.projection.baseline.panel.years=c("2019"),
        sgp.projection.baseline.grade.sequences=list(c("3")),
        sgp.projection.sequence="READING_GRADE_3"),
    READING.2019 = list(
        sgp.content.areas=c("READING", "READING", "READING"),
        sgp.baseline.content.areas=c("READING", "READING", "READING"),
        sgp.baseline.panel.years=c("2016", "2017", "2019"),
        sgp.panel.years=c("2016", "2017", "2019"),
        sgp.grade.sequences=list(c("3", "4", "6")),
        sgp.baseline.grade.sequences=list(c("3", "4", "6")),
        sgp.projection.baseline.content.areas=rep("READING", 2),
        sgp.projection.baseline.panel.years=c("2018", "2019"),
        sgp.projection.baseline.grade.sequences=list(c("3", "4")),
        sgp.projection.sequence="READING_GRADE_4"),
    READING.2019 = list(
        sgp.content.areas=c("READING", "READING", "READING"),
        sgp.baseline.content.areas=c("READING", "READING", "READING"),
        sgp.baseline.panel.years=c("2016", "2017", "2019"),
        sgp.panel.years=c("2016", "2017", "2019"),
        sgp.grade.sequences=list(c("4", "5", "7")),
        sgp.baseline.grade.sequences=list(c("4", "5", "7")),
        sgp.projection.baseline.content.areas=rep("READING", 2),
        sgp.projection.baseline.panel.years=c("2018", "2019"),
        sgp.projection.baseline.grade.sequences=list(c("4", "5")),
        sgp.projection.sequence="READING_GRADE_5"),
    READING.2019 = list(
        sgp.content.areas=c("READING", "READING", "READING"),
        sgp.baseline.content.areas=c("READING", "READING", "READING"),
        sgp.baseline.panel.years=c("2016", "2017", "2019"),
        sgp.panel.years=c("2016", "2017", "2019"),
        sgp.grade.sequences=list(c("5", "6", "8")),
        sgp.baseline.grade.sequences=list(c("5", "6", "8")),
        sgp.projection.baseline.content.areas=rep("READING", 2),
        sgp.projection.baseline.panel.years=c("2018", "2019"),
        sgp.projection.baseline.grade.sequences=list(c("5", "6")),
        sgp.projection.sequence="READING_GRADE_6"),
    READING.2019 = list(
        sgp.content.areas=c("READING", "READING", "READING"),
        sgp.baseline.content.areas=c("READING", "READING", "READING"),
        sgp.baseline.panel.years=c("2015", "2016", "2019"),
        sgp.panel.years=c("2015", "2016", "2019"),
        sgp.grade.sequences=list(c("7", "8", "11")),
        sgp.baseline.grade.sequences=list(c("7", "8", "11")),
        sgp.projection.baseline.content.areas=rep("READING", 2),
        sgp.projection.baseline.panel.years=c("2017", "2018"),
        sgp.projection.baseline.grade.sequences=list(c("7", "8")),
        sgp.projection.sequence="READING_GRADE_8")
)
