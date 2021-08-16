suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(MAST))

args <- commandArgs(trailingOnly = TRUE)

# command line arguments
cluster_num <- args[1]
path_out <- args[2]

pairwise_de <- function(df1, df2, path_out){
	# ORdered data frame
	o_df <- rbind(df1, df2)
	condition <- rep(c(1, 2), times=c(nrow(df1), nrow(df2)))

	# Prepare for MAST
	wellKey <- rownames(o_df)
	cdata <- data.frame(cbind(wellKey=wellKey, condition=condition))
	fdata <- data.frame(primerid=colnames(o_df))

	# SCa data
	sca <- FromMatrix( t(o_df), cdata, fdata)
	cdr2 <-colSums(assay(sca)>0)
	colData(sca)$cngeneson <- scale(cdr2)
    colData(sca)$cond <- factor(unlist(as.list(condition)))
    colData(sca)$cond <- relevel(colData(sca)$cond, 2)

    # Fits
    zlmCond <- zlm(~cond + cngeneson, sca)
    summaryDt <- summary(zlmCond, doLRT='cond1')$datatable

	# Significance table
	fcHurdle <- merge(summaryDt[contrast=='cond1' & component=='H',.(primerid, `Pr(>Chisq)`)],
		summaryDt[contrast=='cond1' & component=='logFC', .(primerid,coef, ci.hi, ci.lo)], by='primerid')

	# FDR
	fcHurdle[,fdr:=p.adjust(`Pr(>Chisq)`, 'fdr')]
	setorder(fcHurdle, fdr)

	# Export data
	write.csv(as.data.frame(fcHurdle), path_out, quote=FALSE)
}

df1 <- readRDS(paste0("df.", cluster_num, ".RDS"))
df2 <- readRDS(paste0("df.", cluster_num, ".rest.RDS"))

pairwise_de(df1, df2, path_out)
