#####
###   Configurations for calculating LAGGED PROJECTIONS in 2021
#####


READING_2021.config <- list(
     READING.2021 = list(
                 sgp.content.areas=c("READING", "READING"),
                 sgp.baseline.content.areas=c("READING", "READING"),
                 sgp.panel.years=c("2019", "2021"),
                 sgp.baseline.panel.years=c("2019", "2021"),
                 sgp.grade.sequences=list(c("3", "5")),
                 sgp.baseline.grade.sequences=list(c("3", "5")),
                 sgp.projection.sequence="READING_GRADE_5"),
     READING.2021 = list(
                 sgp.content.areas=c("READING", "READING", "READING"),
                 sgp.baseline.content.areas=c("READING", "READING", "READING"),
                 sgp.baseline.panel.years=c("2018", "2019", "2021"),
                 sgp.panel.years=c("2018", "2019", "2021"),
                 sgp.grade.sequences=list(c("3", "4", "6")),
                 sgp.baseline.grade.sequences=list(c("3", "4", "6")),
                 sgp.projection.sequence="READING_GRADE_6"),
     READING.2021 = list(
                 sgp.content.areas=c("READING", "READING", "READING"),
                 sgp.baseline.content.areas=c("READING", "READING", "READING"),
                 sgp.baseline.panel.years=c("2018", "2019", "2021"),
                 sgp.panel.years=c("2018", "2019", "2021"),
                 sgp.grade.sequences=list(c("4", "5", "7")),
                 sgp.baseline.grade.sequences=list(c("4", "5", "7")),
                 sgp.projection.sequence="READING_GRADE_7"),
     READING.2021 = list(
                 sgp.content.areas=c("READING", "READING", "READING"),
                 sgp.baseline.content.areas=c("READING", "READING", "READING"),
                 sgp.baseline.panel.years=c("2018", "2019", "2021"),
                 sgp.panel.years=c("2018", "2019", "2021"),
                 sgp.grade.sequences=list(c("5", "6", "8")),
                 sgp.baseline.grade.sequences=list(c("5", "6", "8")),
                 sgp.projection.sequence="READING_GRADE_8"))
