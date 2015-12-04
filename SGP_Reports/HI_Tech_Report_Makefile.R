
#######
# 2015
#######

load("/Users/avi/Dropbox/SGP/Hawaii/Data/Hawaii_SGP.Rdata")
setwd("/Users/avi/Dropbox/Github_Repos/Documentation/Hawaii/SGP_Reports/2015")

###  Clean up the GoFit Plot directories

# gof <- "/Users/avi/Dropbox/Github_Repos/Documentation/Hawaii/SGP_Reports/img/Goodness_of_Fit"
# tmp_files <- grep("2014", list.files(gof), value = TRUE)
# tmp_files <- grep("2015", list.files(gof), value = TRUE)
# 
# for (k in tmp_files) {
# 	tmp_rm <- grep(".pdf", list.files(paste(gof, k, sep="/")), value = TRUE)
# 	if (length(tmp_rm) > 0) unlink(paste(gof, k, tmp_rm, sep="/"))
# }


library(SGPreports)
use.data.table()

renderMultiDocument(rmd_input = "Hawaii_SGP_Report_2015.Rmd",
										output_format = c("HTML", "PDF"), #, "EPUB", "DOCX"
										cover_img="../img/cover.jpg",
										add_cover_title=TRUE, 
										#cleanup_aux_files = FALSE,
										pandoc_args = "--webtex")

renderMultiDocument(rmd_input = "Appendix_A_2015.Rmd",
										output_format = c("HTML", "PDF"), #, "EPUB", "DOCX"
										cover_img="../img/cover.jpg",
										add_cover_title=TRUE)#,
										# cleanup_aux_files = FALSE)

renderMultiDocument(rmd_input = "Appendix_B.Rmd",
										output_format = c("HTML", "EPUB", "PDF"), #, "DOCX"
										cover_img="../img/cover.jpg",
										add_cover_title=TRUE,
										# self_contained = FALSE,
										# cleanup_aux_files = FALSE,
										pandoc_args = "--webtex")

renderMultiDocument(rmd_input = "Appendix_C_2015.Rmd",
										output_format = c("HTML", "PDF"), #, "DOCX"
										# cleanup_aux_files = FALSE)
										cover_img="../img/cover.jpg",
										add_cover_title=TRUE)#,
