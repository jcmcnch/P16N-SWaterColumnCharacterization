#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
library(oce)

#read in CTD file
d <- read.csv(args[1], sep=',')

#get CTD basics
salinity <- d[["CTDSAL"]]
temperature <- d[["CTDTMP"]]
pressure <- d[["CTDPRS"]]

#additional data
chlfluor <- d[["CTDFLUOR"]]
ctdoxy <- d[["CTDOXY"]]
beamatt <- d[["CTDBEAMCP"]]

#make CTD object
ctd <- as.ctd(salinity, temperature, pressure)

#add additional data to CTD object
ctd <- oceSetData(ctd, 'Chlorophyll Fluorescence (0-5V DC)', value=chlfluor)
ctd <- oceSetData(ctd, 'CTD Oxygen (µm/kg)', value=ctdoxy)
ctd <- oceSetData(ctd, 'Beam Attenuation (1/m)', value=beamatt)

#make plot
pdf(args[2], width=9,height=7)
#multiple columns
par(mfrow=c(1,6), mar=c(0,0,0,0))
#plot templerature profile
plotProfile(ctd, xtype="temperature", ylim=c(300, 0), xlim=c(0,25))
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
plotProfile(ctd, xtype="Chlorophyll Fluorescence (05-V DC)", ylim=c(300, 0), col="darkgreen", xlab="")
#plotProfile(ctd, xtype="CTD Oxygen (µM)", ylim=c(300, 0), col="darkblue", xlab="")
#plotProfile(ctd, xtype="Beam Attenuation (1/m)", ylim=c(300, 0), col="red", xlab="")
dev.off()
