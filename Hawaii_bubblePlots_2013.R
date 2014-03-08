###################################################################################
###
### Script to generate Hawaii bubblePlots for 2013
###
###################################################################################

### Load SGP package

require(SGP)
require(data.table)
options(error=recover)


### Utility functions

percent_in_category <- function(x, in.categories, of.categories, result.digits=1) { ## NOTE: x must be a factor and categories levels
      if (!is.list(in.categories)) in.categories <- list(in.categories)
          if (!is.list(of.categories)) of.categories <- list(of.categories)
          tmp.result <- list()
          tmp <- summary(x[!is.na(x)])
          for (i in seq(length(in.categories))) {
                  tmp.result[[i]] <- round(100*sum(tmp[in.categories[[i]]])/sum(tmp[of.categories[[i]]]), digits=result.digits)
          }
          return(unlist(tmp.result))
}

### Load data

#load("Data/Hawaii_SGP.Rdata")
Zones_for_School_Innovation <- c(368, 380, 353, 354, 370, 379, 381, 383, 391, 261, 262, 263, 257, 258, 270, 271, 272, 273)


### Create summary data

bPlot.data.school <- Hawaii_SGP@Data[VALID_CASE=="VALID_CASE" & SCHOOL_ENROLLMENT_STATUS=="Enrolled School: Yes" & !is.na(SGP)][, 
	list(as.numeric(median(SGP, na.rm=TRUE)), mean(SCALE_SCORE_PRIOR_STANDARDIZED, na.rm=TRUE), 
		percent_in_category(ACHIEVEMENT_LEVEL_PRIOR, c("Meets Proficiency", "Exceeds Proficiency"), c("Well Below Proficiency", "Approaches Proficiency", "Meets Proficiency", "Exceeds Proficiency")), .N), 
	keyby=list(YEAR, CONTENT_AREA, SCHOOL_NUMBER, SCHOOL_NAME, COMPLEX_AREA_NUMBER, COMPLEX_AREA_NAME)]
setnames(bPlot.data.school, c("V1", "V2", "V3", "N"), c("MEDIAN_SGP", "MEAN_SCALE_SCORE_PRIOR_STANDARDIZED", "PERCENT_AT_ABOVE_PROFICIENT_PRIOR", "MEDIAN_SGP_COUNT"))


#### Bubble Plot 1a: Growth by Prior Achievement (WHOLE_STATE with Zones for School Innovation highlighted)

for (i in c("MATHEMATICS", "READING")) {
for (j in sort(unique(bPlot.data.school$YEAR))) {
tmp.bPlot.data.school <- subset(bPlot.data.school, CONTENT_AREA==i & YEAR==j & MEDIAN_SGP_COUNT >= 20)

bPlot.message <- paste("grid.text(", j, ", x=unit(50, 'native'), y=unit(50, 'native'), rot=-30, gp=gpar(col='grey80', cex=14, alpha=0.8, fontface=2))")

bubblePlot(
        bubble_plot_data.X=tmp.bPlot.data.school[["MEDIAN_SGP"]],
        bubble_plot_data.Y=tmp.bPlot.data.school[["PERCENT_AT_ABOVE_PROFICIENT_PRIOR"]],
        bubble_plot_data.SUBSET=which(tmp.bPlot.data.school[["SCHOOL_NUMBER"]] %in% Zones_for_School_Innovation),
        bubble_plot_data.INDICATE=NULL,
        bubble_plot_data.BUBBLE_CENTER_LABEL=NULL,
        bubble_plot_data.SIZE=tmp.bPlot.data.school[["MEDIAN_SGP_COUNT"]],
        bubble_plot_data.LEVELS=NULL,
        bubble_plot_data.BUBBLE_TIPS_LINES=list(
                paste(tmp.bPlot.data.school[["MEDIAN_SGP"]], " (", tmp.bPlot.data.school[["MEDIAN_SGP_COUNT"]], ")", sep=""),
                tmp.bPlot.data.school[["PERCENT_AT_ABOVE_PROFICIENT_PRIOR"]]),
        bubble_plot_labels.X=c("Growth", paste(j, "Median Student Growth Percentile")),
        bubble_plot_labels.Y=c("Achievement", paste(as.numeric(j)-1, "Percent at/above Proficient (Prior)")),
        bubble_plot_labels.SIZE=c(50, 100, 250, 500),
        bubble_plot_labels.LEVELS=NULL,
        bubble_plot_labels.BUBBLE_TIPS_LINES=list(
                paste(j, "Median SGP (Count)"),
                paste(as.numeric(j)-1, "Percent at/above Proficient")),
        bubble_plot_labels.BUBBLE_TITLES=tmp.bPlot.data.school[["SCHOOL_NAME"]],
        bubble_plot_titles.MAIN=paste(capwords(i), "Growth & Achievement"),
        bubble_plot_titles.SUB1=paste(j, "School Performance"),
        bubble_plot_titles.SUB2=paste(j, capwords(i)),
        bubble_plot_titles.LEGEND1="School Size",
        bubble_plot_titles.LEGEND2_P1=NULL,
        bubble_plot_titles.LEGEND2_P2=NULL,
        bubble_plot_configs.BUBBLE_MIN_MAX=c(0.04, 0.11),
        bubble_plot_configs.BUBBLE_X_TICKS=seq(0,100,10),
        bubble_plot_configs.BUBBLE_X_TICKS_SIZE=c(rep(0.6, 5), 1, rep(0.6, 5)),
        bubble_plot_configs.BUBBLE_Y_TICKS=seq(0,100,10),
        bubble_plot_configs.BUBBLE_SUBSET_INCREASE=0.00,
        bubble_plot_configs.BUBBLE_COLOR=NULL,
        bubble_plot_configs.BUBBLE_SUBSET_ALPHA=list(Transparent=0.3, Opaque=0.9),
        bubble_plot_configs.BUBBLE_TIPS="TRUE",
        bubble_plot_configs.BUBBLE_PLOT_DEVICE="PDF",
        bubble_plot_configs.BUBBLE_PLOT_FORMAT="presentation",
        bubble_plot_configs.BUBBLE_PLOT_LEGEND="TRUE",
        bubble_plot_configs.BUBBLE_PLOT_TITLE="TRUE",
        bubble_plot_configs.BUBBLE_PLOT_EXTRAS=bPlot.message,
        bubble_plot_configs.BUBBLE_PLOT_NAME=paste(paste(j, capwords(i), "Zones_for_School_Innovation_Performance", sep="_"), ".pdf", sep=""),
        bubble_plot_configs.BUBBLE_PLOT_PATH=file.path("Visualizations", "bubblePlots", "Zones_for_School_Innovation_Performance"),
        bubble_plot_pdftk.CREATE_CATALOG=FALSE)
}
}

