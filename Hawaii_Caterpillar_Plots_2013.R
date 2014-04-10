##################################################################
###
### Code to produce catapillar plots for teachers
###
##################################################################

### Load data

#load("Data/Hawaii_SGP.Rdata")


### Create teacher tables

Hawaii_Teacher <- subset(Hawaii_SGP@Summary$STATE[[139]], YEAR=="2013" & INSTRUCTOR_ENROLLMENT_STATUS=="Enrolled Instructor: Yes" & MEDIAN_SGP_COUNT >= 10)
Hawaii_Teacher_by_Content_Area <- subset(Hawaii_SGP@Summary$STATE[[140]], YEAR=="2013" & INSTRUCTOR_ENROLLMENT_STATUS=="Enrolled Instructor: Yes" & MEDIAN_SGP_COUNT >= 10)

### Define constants

lower.cut <- 35; upper.cut <- 65; sd.multiplier <- 1

############################################################################################################
###
### Create plots (ACROSS CONTENT AREA)
###
############################################################################################################


pdf(file=paste("Visualizations/Catapillar_Plots/Hawaii_Teacher_Catapillar_Plot_", sd.multiplier, "SD.pdf", sep=""), width=11, height=8.5)

	x.coors <- seq(dim(Hawaii_Teacher)[1])
	median.sgps <- Hawaii_Teacher$MEDIAN_SGP[order(Hawaii_Teacher$MEDIAN_SGP)]
	upper.bounds <- pmin(median.sgps + sd.multiplier*Hawaii_Teacher$MEDIAN_SGP_STANDARD_ERROR[order(Hawaii_Teacher$MEDIAN_SGP)], 99)
	lower.bounds <- pmax(median.sgps - sd.multiplier*Hawaii_Teacher$MEDIAN_SGP_STANDARD_ERROR[order(Hawaii_Teacher$MEDIAN_SGP)], 1)

	plot(Hawaii_Teacher$MEDIAN_SGP[order(Hawaii_Teacher$MEDIAN_SGP)], 
		main=paste("Median Teacher Student Growth Percentile +/-", sd.multiplier, "Standard Error"), 
		xlab="Median SGP Teacher Rank", ylab="Median SGP", pch=20, col="black")

	abline(h=50, lty=2, col="grey50", lwd=2)
	abline(h=upper.cut, lty=3, col="green", lwd=0.5)
	abline(h=lower.cut, lty=3, col="red", lwd=0.5)
	
	arrows(x.coors, median.sgps, x.coors, upper.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	arrows(x.coors, median.sgps, x.coors, lower.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	points(x.coors, median.sgps, pch=20, col="black")

dev.off()


### By position

pdf(file=paste("Visualizations/Catapillar_Plots/Hawaii_Teacher_Catapillar_Plot_LT", lower.cut, "_", sd.multiplier, "SD.pdf", sep=""), width=11, height=8.5)

	x.coors <- seq(dim(Hawaii_Teacher)[1])
	median.sgps <- Hawaii_Teacher$MEDIAN_SGP[order(Hawaii_Teacher$MEDIAN_SGP)]
	upper.bounds <- pmin(median.sgps + sd.multiplier*Hawaii_Teacher$MEDIAN_SGP_STANDARD_ERROR[order(Hawaii_Teacher$MEDIAN_SGP)], 99)
	lower.bounds <- pmax(median.sgps - sd.multiplier*Hawaii_Teacher$MEDIAN_SGP_STANDARD_ERROR[order(Hawaii_Teacher$MEDIAN_SGP)], 1)

	plot(Hawaii_Teacher$MEDIAN_SGP[order(Hawaii_Teacher$MEDIAN_SGP)], 
		main=paste("Median Teacher Student Growth Percentile +/-", sd.multiplier, "Standard Error"), 
		xlab="Median SGP Teacher Rank", ylab="Median SGP", pch=20, col="black")

	abline(h=50, lty=2, col="grey50", lwd=2)
	abline(h=upper.cut, lty=3, col="green", lwd=0.5)
	abline(h=lower.cut, lty=3, col="red", lwd=0.5)
	
	arrows(x.coors, median.sgps, x.coors, upper.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	arrows(x.coors, median.sgps, x.coors, lower.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	points(x.coors, median.sgps, pch=20, col="black")

	color.points <- which(upper.bounds < lower.cut)
	arrows(color.points, median.sgps[color.points], color.points, upper.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(1,0,0,0.25))
	arrows(color.points, median.sgps[color.points], color.points, lower.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(1,0,0,0.25))
	points(color.points, median.sgps[color.points], pch=20, col="red")

	percentage.teachers <- round(100*as.numeric(summary(upper.bounds < lower.cut)[["TRUE"]])/(as.numeric(summary(upper.bounds < lower.cut)[["TRUE"]])+as.numeric(summary(upper.bounds < lower.cut)[["FALSE"]])), digits=1)

	text(length(x.coors)/2, y=75, paste(percentage.teachers, "%", sep=""), cex=4, col="red")
	
dev.off()



pdf(file=paste("Visualizations/Catapillar_Plots/Hawaii_Teacher_Catapillar_Plot_LT50_", sd.multiplier, "SD.pdf", sep=""), width=11, height=8.5)

	x.coors <- seq(dim(Hawaii_Teacher)[1])
	median.sgps <- Hawaii_Teacher$MEDIAN_SGP[order(Hawaii_Teacher$MEDIAN_SGP)]
	upper.bounds <- pmin(median.sgps + sd.multiplier*Hawaii_Teacher$MEDIAN_SGP_STANDARD_ERROR[order(Hawaii_Teacher$MEDIAN_SGP)], 99)
	lower.bounds <- pmax(median.sgps - sd.multiplier*Hawaii_Teacher$MEDIAN_SGP_STANDARD_ERROR[order(Hawaii_Teacher$MEDIAN_SGP)], 1)

	plot(Hawaii_Teacher$MEDIAN_SGP[order(Hawaii_Teacher$MEDIAN_SGP)], 
		main=paste("Median Teacher Student Growth Percentile +/-", sd.multiplier, "Standard Error"), 
		xlab="Median SGP Teacher Rank", ylab="Median SGP", pch=20, col="black")

	abline(h=50, lty=2, col="grey50", lwd=2)
	abline(h=upper.cut, lty=3, col="green", lwd=0.5)
	abline(h=lower.cut, lty=3, col="red", lwd=0.5)
	
	arrows(x.coors, median.sgps, x.coors, upper.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	arrows(x.coors, median.sgps, x.coors, lower.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	points(x.coors, median.sgps, pch=20, col="black")

	my.condition <- upper.bounds < 50 & upper.bounds >= lower.cut 
	color.points <- which(my.condition)
	arrows(color.points, median.sgps[color.points], color.points, upper.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(1,0.647,0,0.25))
	arrows(color.points, median.sgps[color.points], color.points, lower.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(1,0.647,0,0.25))
	points(color.points, median.sgps[color.points], pch=20, col="orange")

	percentage.teachers <- round(100*as.numeric(summary(my.condition)[["TRUE"]])/(as.numeric(summary(my.condition)[["TRUE"]])+as.numeric(summary(my.condition)[["FALSE"]])), digits=1)

	text(length(x.coors)/2, y=75, paste(percentage.teachers, "%", sep=""), cex=4, col="orange")
	
dev.off()



pdf(file=paste("Visualizations/Catapillar_Plots/Hawaii_Teacher_Catapillar_Plot_CONTAINS50_", sd.multiplier, "SD.pdf", sep=""), width=11, height=8.5)

	x.coors <- seq(dim(Hawaii_Teacher)[1])
	median.sgps <- Hawaii_Teacher$MEDIAN_SGP[order(Hawaii_Teacher$MEDIAN_SGP)]
	upper.bounds <- pmin(median.sgps + sd.multiplier*Hawaii_Teacher$MEDIAN_SGP_STANDARD_ERROR[order(Hawaii_Teacher$MEDIAN_SGP)], 99)
	lower.bounds <- pmax(median.sgps - sd.multiplier*Hawaii_Teacher$MEDIAN_SGP_STANDARD_ERROR[order(Hawaii_Teacher$MEDIAN_SGP)], 1)

	plot(Hawaii_Teacher$MEDIAN_SGP[order(Hawaii_Teacher$MEDIAN_SGP)], 
		main=paste("Median Teacher Student Growth Percentile +/-", sd.multiplier, "Standard Error"), 
		xlab="Median SGP Teacher Rank", ylab="Median SGP", pch=20, col="black")

	abline(h=50, lty=2, col="grey50", lwd=2)
	abline(h=upper.cut, lty=3, col="green", lwd=0.5)
	abline(h=lower.cut, lty=3, col="red", lwd=0.5)
	
	arrows(x.coors, median.sgps, x.coors, upper.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	arrows(x.coors, median.sgps, x.coors, lower.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	points(x.coors, median.sgps, pch=20, col="black")

	my.condition <- upper.bounds >= 50 & lower.bounds <= 50
	color.points <- which(my.condition)
	arrows(color.points, median.sgps[color.points], color.points, upper.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(1,1,0,0.25))
	arrows(color.points, median.sgps[color.points], color.points, lower.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(1,1,0,0.25))
	points(color.points, median.sgps[color.points], pch=20, col="yellow")

	percentage.teachers <- round(100*as.numeric(summary(my.condition)[["TRUE"]])/(as.numeric(summary(my.condition)[["TRUE"]])+as.numeric(summary(my.condition)[["FALSE"]])), digits=1)

	text(length(x.coors)/2, y=75, paste(percentage.teachers, "%", sep=""), cex=4, col="yellow")
	
dev.off()




pdf(file=paste("Visualizations/Catapillar_Plots/Hawaii_Teacher_Catapillar_Plot_GT50_", sd.multiplier, "SD.pdf", sep=""), width=11, height=8.5)

	x.coors <- seq(dim(Hawaii_Teacher)[1])
	median.sgps <- Hawaii_Teacher$MEDIAN_SGP[order(Hawaii_Teacher$MEDIAN_SGP)]
	upper.bounds <- pmin(median.sgps + sd.multiplier*Hawaii_Teacher$MEDIAN_SGP_STANDARD_ERROR[order(Hawaii_Teacher$MEDIAN_SGP)], 99)
	lower.bounds <- pmax(median.sgps - sd.multiplier*Hawaii_Teacher$MEDIAN_SGP_STANDARD_ERROR[order(Hawaii_Teacher$MEDIAN_SGP)], 1)

	plot(Hawaii_Teacher$MEDIAN_SGP[order(Hawaii_Teacher$MEDIAN_SGP)], 
		main=paste("Median Teacher Student Growth Percentile +/-", sd.multiplier, "Standard Error"), 
		xlab="Median SGP Teacher Rank", ylab="Median SGP", pch=20, col="black")

	abline(h=50, lty=2, col="grey50", lwd=2)
	abline(h=upper.cut, lty=3, col="green", lwd=0.5)
	abline(h=lower.cut, lty=3, col="red", lwd=0.5)
	
	arrows(x.coors, median.sgps, x.coors, upper.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	arrows(x.coors, median.sgps, x.coors, lower.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	points(x.coors, median.sgps, pch=20, col="black")

	my.condition <- lower.bounds > 50 & lower.bounds <= upper.cut
	color.points <- which(my.condition)
	arrows(color.points, median.sgps[color.points], color.points, upper.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(0,1,0,0.25))
	arrows(color.points, median.sgps[color.points], color.points, lower.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(0,1,0,0.25))
	points(color.points, median.sgps[color.points], pch=20, col="green")

	percentage.teachers <- round(100*as.numeric(summary(my.condition)[["TRUE"]])/(as.numeric(summary(my.condition)[["TRUE"]])+as.numeric(summary(my.condition)[["FALSE"]])), digits=1)

	text(length(x.coors)/2, y=75, paste(percentage.teachers, "%", sep=""), cex=4, col="green")
	
dev.off()



pdf(file=paste("Visualizations/Catapillar_Plots/Hawaii_Teacher_Catapillar_Plot_GT", upper.cut, "_", sd.multiplier, "SD.pdf", sep=""), width=11, height=8.5)

	x.coors <- seq(dim(Hawaii_Teacher)[1])
	median.sgps <- Hawaii_Teacher$MEDIAN_SGP[order(Hawaii_Teacher$MEDIAN_SGP)]
	upper.bounds <- pmin(median.sgps + sd.multiplier*Hawaii_Teacher$MEDIAN_SGP_STANDARD_ERROR[order(Hawaii_Teacher$MEDIAN_SGP)], 99)
	lower.bounds <- pmax(median.sgps - sd.multiplier*Hawaii_Teacher$MEDIAN_SGP_STANDARD_ERROR[order(Hawaii_Teacher$MEDIAN_SGP)], 1)

	plot(Hawaii_Teacher$MEDIAN_SGP[order(Hawaii_Teacher$MEDIAN_SGP)], 
		main=paste("Median Teacher Student Growth Percentile +/-", sd.multiplier, "Standard Error"), 
		xlab="Median SGP Teacher Rank", ylab="Median SGP", pch=20, col="black")

	abline(h=50, lty=2, col="grey50", lwd=2)
	abline(h=upper.cut, lty=3, col="green", lwd=0.5)
	abline(h=lower.cut, lty=3, col="red", lwd=0.5)
	
	arrows(x.coors, median.sgps, x.coors, upper.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	arrows(x.coors, median.sgps, x.coors, lower.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	points(x.coors, median.sgps, pch=20, col="black")

	my.condition <- lower.bounds > upper.cut
	color.points <- which(my.condition)
	arrows(color.points, median.sgps[color.points], color.points, upper.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(0,0,1,0.25))
	arrows(color.points, median.sgps[color.points], color.points, lower.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(0,0,1,0.25))
	points(color.points, median.sgps[color.points], pch=20, col="blue")

	percentage.teachers <- round(100*as.numeric(summary(my.condition)[["TRUE"]])/(as.numeric(summary(my.condition)[["TRUE"]])+as.numeric(summary(my.condition)[["FALSE"]])), digits=1)

	text(length(x.coors)/2, y=75, paste(percentage.teachers, "%", sep=""), cex=4, col="blue")
	
dev.off()


############################################################################################################
###
### Create plots (WITHIN CONTENT AREA)
###
############################################################################################################

### MATHEMATICS

tmp.data <- subset(Hawaii_Teacher_by_Content_Area, CONTENT_AREA=="MATHEMATICS")

pdf(file=paste("Visualizations/Catapillar_Plots/Hawaii_Teacher_Catapillar_Plot_MATHEMATICS_", sd.multiplier, "SD.pdf", sep=""), width=11, height=8.5)

	x.coors <- seq(dim(tmp.data)[1])
	median.sgps <- tmp.data$MEDIAN_SGP[order(tmp.data$MEDIAN_SGP)]
	upper.bounds <- pmin(median.sgps + sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 99)
	lower.bounds <- pmax(median.sgps - sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 1)

	plot(median.sgps, 
		main=paste("Median Teacher Student Growth Percentile +/-", sd.multiplier, "Standard Error"), 
		xlab="Median SGP Teacher Rank", ylab="Median SGP", pch=20, col="black")

	abline(h=50, lty=2, col="grey50", lwd=2)
	abline(h=upper.cut, lty=3, col="green", lwd=0.5)
	abline(h=lower.cut, lty=3, col="red", lwd=0.5)
	
	arrows(x.coors, median.sgps, x.coors, upper.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	arrows(x.coors, median.sgps, x.coors, lower.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	points(x.coors, median.sgps, pch=20, col="black")

dev.off()


### By position

pdf(file=paste("Visualizations/Catapillar_Plots/Hawaii_Teacher_Catapillar_Plot_LT", lower.cut, "_MATHEMATICS.pdf", sep=""), width=11, height=8.5)

	x.coors <- seq(dim(tmp.data)[1])
	median.sgps <- tmp.data$MEDIAN_SGP[order(tmp.data$MEDIAN_SGP)]
	upper.bounds <- pmin(median.sgps + sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 99)
	lower.bounds <- pmax(median.sgps - sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 1)

	plot(median.sgps, 
		main=paste("Median Teacher Student Growth Percentile +/-", sd.multiplier, "Standard Error"), 
		xlab="Median SGP Teacher Rank", ylab="Median SGP", pch=20, col="black")

	abline(h=50, lty=2, col="grey50", lwd=2)
	abline(h=upper.cut, lty=3, col="green", lwd=0.5)
	abline(h=lower.cut, lty=3, col="red", lwd=0.5)
	
	arrows(x.coors, median.sgps, x.coors, upper.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	arrows(x.coors, median.sgps, x.coors, lower.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	points(x.coors, median.sgps, pch=20, col="black")

	my.condition <- upper.bounds < lower.cut 
	color.points <- which(my.condition)
	arrows(color.points, median.sgps[color.points], color.points, upper.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(1,0,0,0.25))
	arrows(color.points, median.sgps[color.points], color.points, lower.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(1,0,0,0.25))
	points(color.points, median.sgps[color.points], pch=20, col="red")

	percentage.teachers <- round(100*as.numeric(summary(my.condition)[["TRUE"]])/(as.numeric(summary(my.condition)[["TRUE"]])+as.numeric(summary(my.condition)[["FALSE"]])), digits=1)

	text(length(x.coors)/2, y=75, paste(percentage.teachers, "%", sep=""), cex=4, col="red")
	
dev.off()


pdf(file=paste("Visualizations/Catapillar_Plots/Hawaii_Teacher_Catapillar_Plot_LT50_MATHEMATICS_", sd.multiplier, "SD.pdf", sep=""), width=11, height=8.5)

	x.coors <- seq(dim(tmp.data)[1])
	median.sgps <- tmp.data$MEDIAN_SGP[order(tmp.data$MEDIAN_SGP)]
	upper.bounds <- pmin(median.sgps + sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 99)
	lower.bounds <- pmax(median.sgps - sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 1)

	plot(median.sgps, 
		main=paste("Median Teacher Student Growth Percentile +/-", sd.multiplier, "Standard Error"), 
		xlab="Median SGP Teacher Rank", ylab="Median SGP", pch=20, col="black")

	abline(h=50, lty=2, col="grey50", lwd=2)
	abline(h=upper.cut, lty=3, col="green", lwd=0.5)
	abline(h=lower.cut, lty=3, col="red", lwd=0.5)
	
	arrows(x.coors, median.sgps, x.coors, upper.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	arrows(x.coors, median.sgps, x.coors, lower.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	points(x.coors, median.sgps, pch=20, col="black")

	my.condition <- upper.bounds < 50 & upper.bounds >= lower.cut 
	color.points <- which(my.condition)
	arrows(color.points, median.sgps[color.points], color.points, upper.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(1,0.647,0,0.25))
	arrows(color.points, median.sgps[color.points], color.points, lower.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(1,0.647,0,0.25))
	points(color.points, median.sgps[color.points], pch=20, col="orange")

	percentage.teachers <- round(100*as.numeric(summary(my.condition)[["TRUE"]])/(as.numeric(summary(my.condition)[["TRUE"]])+as.numeric(summary(my.condition)[["FALSE"]])), digits=1)

	text(length(x.coors)/2, y=75, paste(percentage.teachers, "%", sep=""), cex=4, col="orange")
	
dev.off()


pdf(file=paste("Visualizations/Catapillar_Plots/Hawaii_Teacher_Catapillar_Plot_CONTAINS50_MATHEMATICS_", sd.multiplier, "SD.pdf", sep=""), width=11, height=8.5)

	x.coors <- seq(dim(tmp.data)[1])
	median.sgps <- tmp.data$MEDIAN_SGP[order(tmp.data$MEDIAN_SGP)]
	upper.bounds <- pmin(median.sgps + sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 99)
	lower.bounds <- pmax(median.sgps - sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 1)

	plot(median.sgps, 
		main=paste("Median Teacher Student Growth Percentile +/-", sd.multiplier, "Standard Error"), 
		xlab="Median SGP Teacher Rank", ylab="Median SGP", pch=20, col="black")

	abline(h=50, lty=2, col="grey50", lwd=2)
	abline(h=upper.cut, lty=3, col="green", lwd=0.5)
	abline(h=lower.cut, lty=3, col="red", lwd=0.5)
	
	arrows(x.coors, median.sgps, x.coors, upper.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	arrows(x.coors, median.sgps, x.coors, lower.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	points(x.coors, median.sgps, pch=20, col="black")

	my.condition <- upper.bounds >= 50 & lower.bounds <= 50
	color.points <- which(my.condition)
	arrows(color.points, median.sgps[color.points], color.points, upper.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(1,1,0,0.25))
	arrows(color.points, median.sgps[color.points], color.points, lower.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(1,1,0,0.25))
	points(color.points, median.sgps[color.points], pch=20, col="yellow")

	percentage.teachers <- round(100*as.numeric(summary(my.condition)[["TRUE"]])/(as.numeric(summary(my.condition)[["TRUE"]])+as.numeric(summary(my.condition)[["FALSE"]])), digits=1)

	text(length(x.coors)/2, y=75, paste(percentage.teachers, "%", sep=""), cex=4, col="yellow")
	
dev.off()



pdf(file=paste("Visualizations/Catapillar_Plots/Hawaii_Teacher_Catapillar_Plot_GT50_MATHEMATICS_", sd.multiplier, "SD.pdf", sep=""), width=11, height=8.5)

	x.coors <- seq(dim(tmp.data)[1])
	median.sgps <- tmp.data$MEDIAN_SGP[order(tmp.data$MEDIAN_SGP)]
	upper.bounds <- pmin(median.sgps + sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 99)
	lower.bounds <- pmax(median.sgps - sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 1)

	plot(median.sgps, 
		main=paste("Median Teacher Student Growth Percentile +/-", sd.multiplier, "Standard Error"), 
		xlab="Median SGP Teacher Rank", ylab="Median SGP", pch=20, col="black")

	abline(h=50, lty=2, col="grey50", lwd=2)
	abline(h=upper.cut, lty=3, col="green", lwd=0.5)
	abline(h=lower.cut, lty=3, col="red", lwd=0.5)
	
	arrows(x.coors, median.sgps, x.coors, upper.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	arrows(x.coors, median.sgps, x.coors, lower.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	points(x.coors, median.sgps, pch=20, col="black")

	my.condition <- lower.bounds > 50 & lower.bounds <= upper.cut
	color.points <- which(my.condition)
	arrows(color.points, median.sgps[color.points], color.points, upper.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(0,1,0,0.25))
	arrows(color.points, median.sgps[color.points], color.points, lower.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(0,1,0,0.25))
	points(color.points, median.sgps[color.points], pch=20, col="green")

	percentage.teachers <- round(100*as.numeric(summary(my.condition)[["TRUE"]])/(as.numeric(summary(my.condition)[["TRUE"]])+as.numeric(summary(my.condition)[["FALSE"]])), digits=1)

	text(length(x.coors)/2, y=75, paste(percentage.teachers, "%", sep=""), cex=4, col="green")
	
dev.off()



pdf(file=paste("Visualizations/Catapillar_Plots/Hawaii_Teacher_Catapillar_Plot_GT", upper.cut, "_MATHEMATICS_", sd.multiplier, "SD.pdf", sep=""), width=11, height=8.5)

	x.coors <- seq(dim(tmp.data)[1])
	median.sgps <- tmp.data$MEDIAN_SGP[order(tmp.data$MEDIAN_SGP)]
	upper.bounds <- pmin(median.sgps + sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 99)
	lower.bounds <- pmax(median.sgps - sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 1)

	plot(median.sgps, 
		main=paste("Median Teacher Student Growth Percentile +/-", sd.multiplier, "Standard Error"), 
		xlab="Median SGP Teacher Rank", ylab="Median SGP", pch=20, col="black")

	abline(h=50, lty=2, col="grey50", lwd=2)
	abline(h=upper.cut, lty=3, col="green", lwd=0.5)
	abline(h=lower.cut, lty=3, col="red", lwd=0.5)
	
	arrows(x.coors, median.sgps, x.coors, upper.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	arrows(x.coors, median.sgps, x.coors, lower.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	points(x.coors, median.sgps, pch=20, col="black")

	my.condition <- lower.bounds > upper.cut
	color.points <- which(my.condition)
	arrows(color.points, median.sgps[color.points], color.points, upper.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(0,0,1,0.25))
	arrows(color.points, median.sgps[color.points], color.points, lower.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(0,0,1,0.25))
	points(color.points, median.sgps[color.points], pch=20, col="blue")

	percentage.teachers <- round(100*as.numeric(summary(my.condition)[["TRUE"]])/(as.numeric(summary(my.condition)[["TRUE"]])+as.numeric(summary(my.condition)[["FALSE"]])), digits=1)

	text(length(x.coors)/2, y=75, paste(percentage.teachers, "%", sep=""), cex=4, col="blue")
	
dev.off()





### READING

tmp.data <- subset(Hawaii_Teacher_by_Content_Area, CONTENT_AREA=="READING")

pdf(file=paste("Visualizations/Catapillar_Plots/Hawaii_Teacher_Catapillar_Plot_READING_", sd.multiplier, "SD.pdf", sep=""), width=11, height=8.5)

	x.coors <- seq(dim(tmp.data)[1])
	median.sgps <- tmp.data$MEDIAN_SGP[order(tmp.data$MEDIAN_SGP)]
	upper.bounds <- pmin(median.sgps + sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 99)
	lower.bounds <- pmax(median.sgps - sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 1)

	plot(median.sgps, 
		main=paste("Median Teacher Student Growth Percentile +/-", sd.multiplier, "Standard Error"), 
		xlab="Median SGP Teacher Rank", ylab="Median SGP", pch=20, col="black")

	abline(h=50, lty=2, col="grey50", lwd=2)
	abline(h=upper.cut, lty=3, col="green", lwd=0.5)
	abline(h=lower.cut, lty=3, col="red", lwd=0.5)
	
	arrows(x.coors, median.sgps, x.coors, upper.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	arrows(x.coors, median.sgps, x.coors, lower.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	points(x.coors, median.sgps, pch=20, col="black")

dev.off()



### By position

pdf(file=paste("Visualizations/Catapillar_Plots/Hawaii_Teacher_Catapillar_Plot_LT", lower.cut, "_READING_", sd.multiplier, "SD.pdf", sep=""), width=11, height=8.5)

	x.coors <- seq(dim(tmp.data)[1])
	median.sgps <- tmp.data$MEDIAN_SGP[order(tmp.data$MEDIAN_SGP)]
	upper.bounds <- pmin(median.sgps + sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 99)
	lower.bounds <- pmax(median.sgps - sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 1)

	plot(median.sgps, 
		main=paste("Median Teacher Student Growth Percentile +/-", sd.multiplier, "Standard Error"), 
		xlab="Median SGP Teacher Rank", ylab="Median SGP", pch=20, col="black")

	abline(h=50, lty=2, col="grey50", lwd=2)
	abline(h=upper.cut, lty=3, col="green", lwd=0.5)
	abline(h=lower.cut, lty=3, col="red", lwd=0.5)
	
	arrows(x.coors, median.sgps, x.coors, upper.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	arrows(x.coors, median.sgps, x.coors, lower.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	points(x.coors, median.sgps, pch=20, col="black")

	my.condition <- upper.bounds < lower.cut 
	color.points <- which(my.condition)
	arrows(color.points, median.sgps[color.points], color.points, upper.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(1,0,0,0.25))
	arrows(color.points, median.sgps[color.points], color.points, lower.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(1,0,0,0.25))
	points(color.points, median.sgps[color.points], pch=20, col="red")

	percentage.teachers <- round(100*as.numeric(summary(my.condition)[["TRUE"]])/(as.numeric(summary(my.condition)[["TRUE"]])+as.numeric(summary(my.condition)[["FALSE"]])), digits=1)

	text(length(x.coors)/2, y=75, paste(percentage.teachers, "%", sep=""), cex=4, col="red")
	
dev.off()


pdf(file=paste("Visualizations/Catapillar_Plots/Hawaii_Teacher_Catapillar_Plot_LT50_READING_", sd.multiplier, "SD.pdf", sep=""), width=11, height=8.5)

	x.coors <- seq(dim(tmp.data)[1])
	median.sgps <- tmp.data$MEDIAN_SGP[order(tmp.data$MEDIAN_SGP)]
	upper.bounds <- pmin(median.sgps + sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 99)
	lower.bounds <- pmax(median.sgps - sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 1)

	plot(median.sgps, 
		main=paste("Median Teacher Student Growth Percentile +/-", sd.multiplier, "Standard Error"), 
		xlab="Median SGP Teacher Rank", ylab="Median SGP", pch=20, col="black")

	abline(h=50, lty=2, col="grey50", lwd=2)
	abline(h=upper.cut, lty=3, col="green", lwd=0.5)
	abline(h=lower.cut, lty=3, col="red", lwd=0.5)
	
	arrows(x.coors, median.sgps, x.coors, upper.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	arrows(x.coors, median.sgps, x.coors, lower.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	points(x.coors, median.sgps, pch=20, col="black")

	my.condition <- upper.bounds < 50 & upper.bounds >= lower.cut 
	color.points <- which(my.condition)
	arrows(color.points, median.sgps[color.points], color.points, upper.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(1,0.647,0,0.25))
	arrows(color.points, median.sgps[color.points], color.points, lower.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(1,0.647,0,0.25))
	points(color.points, median.sgps[color.points], pch=20, col="orange")

	percentage.teachers <- round(100*as.numeric(summary(my.condition)[["TRUE"]])/(as.numeric(summary(my.condition)[["TRUE"]])+as.numeric(summary(my.condition)[["FALSE"]])), digits=1)

	text(length(x.coors)/2, y=75, paste(percentage.teachers, "%", sep=""), cex=4, col="orange")
	
dev.off()


pdf(file=paste("Visualizations/Catapillar_Plots/Hawaii_Teacher_Catapillar_Plot_CONTAINS50_READING_", sd.multiplier, "SD.pdf", sep=""), width=11, height=8.5)

	x.coors <- seq(dim(tmp.data)[1])
	median.sgps <- tmp.data$MEDIAN_SGP[order(tmp.data$MEDIAN_SGP)]
	upper.bounds <- pmin(median.sgps + sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 99)
	lower.bounds <- pmax(median.sgps - sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 1)

	plot(median.sgps, 
		main=paste("Median Teacher Student Growth Percentile +/-", sd.multiplier, "Standard Error"), 
		xlab="Median SGP Teacher Rank", ylab="Median SGP", pch=20, col="black")

	abline(h=50, lty=2, col="grey50", lwd=2)
	abline(h=upper.cut, lty=3, col="green", lwd=0.5)
	abline(h=lower.cut, lty=3, col="red", lwd=0.5)
	
	arrows(x.coors, median.sgps, x.coors, upper.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	arrows(x.coors, median.sgps, x.coors, lower.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	points(x.coors, median.sgps, pch=20, col="black")

	my.condition <- upper.bounds >= 50 & lower.bounds <= 50
	color.points <- which(my.condition)
	arrows(color.points, median.sgps[color.points], color.points, upper.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(1,1,0,0.25))
	arrows(color.points, median.sgps[color.points], color.points, lower.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(1,1,0,0.25))
	points(color.points, median.sgps[color.points], pch=20, col="yellow")

	percentage.teachers <- round(100*as.numeric(summary(my.condition)[["TRUE"]])/(as.numeric(summary(my.condition)[["TRUE"]])+as.numeric(summary(my.condition)[["FALSE"]])), digits=1)

	text(length(x.coors)/2, y=75, paste(percentage.teachers, "%", sep=""), cex=4, col="yellow")
	
dev.off()



pdf(file=paste("Visualizations/Catapillar_Plots/Hawaii_Teacher_Catapillar_Plot_GT50_READING_", sd.multiplier, "SD.pdf", sep=""), width=11, height=8.5)

	x.coors <- seq(dim(tmp.data)[1])
	median.sgps <- tmp.data$MEDIAN_SGP[order(tmp.data$MEDIAN_SGP)]
	upper.bounds <- pmin(median.sgps + sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 99)
	lower.bounds <- pmax(median.sgps - sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 1)

	plot(median.sgps, 
		main=paste("Median Teacher Student Growth Percentile +/-", sd.multiplier, "Standard Error"), 
		xlab="Median SGP Teacher Rank", ylab="Median SGP", pch=20, col="black")

	abline(h=50, lty=2, col="grey50", lwd=2)
	abline(h=upper.cut, lty=3, col="green", lwd=0.5)
	abline(h=lower.cut, lty=3, col="red", lwd=0.5)
	
	arrows(x.coors, median.sgps, x.coors, upper.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	arrows(x.coors, median.sgps, x.coors, lower.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	points(x.coors, median.sgps, pch=20, col="black")

	my.condition <- lower.bounds > 50 & lower.bounds <= upper.cut
	color.points <- which(my.condition)
	arrows(color.points, median.sgps[color.points], color.points, upper.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(0,1,0,0.25))
	arrows(color.points, median.sgps[color.points], color.points, lower.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(0,1,0,0.25))
	points(color.points, median.sgps[color.points], pch=20, col="green")

	percentage.teachers <- round(100*as.numeric(summary(my.condition)[["TRUE"]])/(as.numeric(summary(my.condition)[["TRUE"]])+as.numeric(summary(my.condition)[["FALSE"]])), digits=1)

	text(length(x.coors)/2, y=75, paste(percentage.teachers, "%", sep=""), cex=4, col="green")
	
dev.off()



pdf(file=paste("Visualizations/Catapillar_Plots/Hawaii_Teacher_Catapillar_Plot_GT", upper.cut, "_READING_", sd.multiplier, "SD.pdf", sep=""), width=11, height=8.5)

	x.coors <- seq(dim(tmp.data)[1])
	median.sgps <- tmp.data$MEDIAN_SGP[order(tmp.data$MEDIAN_SGP)]
	upper.bounds <- pmin(median.sgps + sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 99)
	lower.bounds <- pmax(median.sgps - sd.multiplier*tmp.data$MEDIAN_SGP_STANDARD_ERROR[order(tmp.data$MEDIAN_SGP)], 1)

	plot(median.sgps, 
		main=paste("Median Teacher Student Growth Percentile +/-", sd.multiplier, "Standard Error"), 
		xlab="Median SGP Teacher Rank", ylab="Median SGP", pch=20, col="black")

	abline(h=50, lty=2, col="grey50", lwd=2)
	abline(h=upper.cut, lty=3, col="green", lwd=0.5)
	abline(h=lower.cut, lty=3, col="red", lwd=0.5)
	
	arrows(x.coors, median.sgps, x.coors, upper.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	arrows(x.coors, median.sgps, x.coors, lower.bounds, lwd=0.1, angle=0, length=0, col=rgb(0.5,0.5,0.5,0.25))
	points(x.coors, median.sgps, pch=20, col="black")

	my.condition <- lower.bounds > upper.cut
	color.points <- which(my.condition)
	arrows(color.points, median.sgps[color.points], color.points, upper.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(0,0,1,0.25))
	arrows(color.points, median.sgps[color.points], color.points, lower.bounds[color.points], lwd=0.1, angle=0, length=0, col=rgb(0,0,1,0.25))
	points(color.points, median.sgps[color.points], pch=20, col="blue")

	percentage.teachers <- round(100*as.numeric(summary(my.condition)[["TRUE"]])/(as.numeric(summary(my.condition)[["TRUE"]])+as.numeric(summary(my.condition)[["FALSE"]])), digits=1)

	text(length(x.coors)/2, y=75, paste(percentage.teachers, "%", sep=""), cex=4, col="blue")
	
dev.off()


