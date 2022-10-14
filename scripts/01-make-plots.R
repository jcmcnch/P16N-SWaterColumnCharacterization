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
chlfluor <- d[["Fluorescence.Raw.Data..arbitrary.units."]]
ctdoxy <- d[["CTDOXY..umol.kg."]]
beamatt <- d[["Transmissometer.Beam.Attenuation..1.m."]]

#make CTD object
ctd <- as.ctd(salinity, temperature, pressure)

#add additional data to CTD object
ctd <- oceSetData(ctd, 'Chlorophyll Fluorescence (raw)', value=chlfluor)
ctd <- oceSetData(ctd, 'CTD Oxygen (µM)', value=ctdoxy)
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
plotProfile(ctd, xtype="Chlorophyll Fluorescence (raw)", ylim=c(300, 0), col="darkgreen", xlab="")
plotProfile(ctd, xtype="CTD Oxygen (µM)", ylim=c(300, 0), col="darkblue", xlab="")
plotProfile(ctd, xtype="Beam Attenuation (1/m)", ylim=c(300, 0), col="red", xlab="")
dev.off()
