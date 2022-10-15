#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
library(oce)

#read in CTD file
d <- read.csv(args[1], sep=',')
#remove null values
d[d==-999] <- NA

#get CTD basics
salinity <- d[["CTDSAL"]]
temperature <- d[["CTDTMP"]]
pressure <- d[["CTDPRS"]]

#additional data
ctdoxy <- d[["CTDOXY"]]
beamatt <- d[["CTDBEAMCP"]]

#make CTD object
ctd <- as.ctd(salinity, temperature, pressure)

#add additional data to CTD object
ctd <- oceSetData(ctd, 'CTD Oxygen (µm/kg)', value=ctdoxy)
ctd <- oceSetData(ctd, 'Beam Attenuation (1/m)', value=beamatt)

#make plot
ylimit=as.double(args[2])
pdf(args[4], width=7,height=9)
#multiple columns
par(mfrow=c(1,3), mar=c(1,1,1,1), oma=c(10,1,1,1))
#plot templerature profile
plotProfile(ctd, xtype="temperature", ylim=c(ylimit, 0), xlim=c(0,25))
temperature <- ctd[["temperature"]]
pressure <- ctd[["pressure"]]
#define MLD with two different methods and plot as line
for (criterion in c(0.1, 0.5)) {
    inMLD <- abs(temperature[1]-temperature) < criterion
    MLDindex <- which.min(inMLD)
    MLDpressure <- pressure[MLDindex]
    abline(h=pressure[MLDindex], lwd=2, lty="dashed")
}
#plot other data sources
plotProfile(ctd, xtype="CTD Oxygen (µm/kg)", ylim=c(ylimit, 0), col="darkblue")
plotProfile(ctd, xtype="Beam Attenuation (1/m)", ylim=c(ylimit, 0), col="red")

#source = https://stackoverflow.com/questions/7367138/text-wrap-for-plot-titles
wrap_strings <- function(vector_of_strings,width){sapply(vector_of_strings,FUN=function(x){paste(strwrap(x,width=width), collapse="\n")})}

mtext(wrap_strings(args[3], 30), outer=TRUE, adj=0.5, padj=1, side=1)

dev.off()
