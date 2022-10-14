#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
library(oce)

#read in CTD file
d <- read.csv(args[1], sep=',')
d[d==-999] <- NA

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
ylimit=strtoi(args[2])
pdf(args[3], width=9,height=7)
#multiple columns
par(mfrow=c(1,6), mar=c(0,0,0,0))
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
plotProfile(ctd, xtype="Chlorophyll Fluorescence (0-5V DC)", ylim=c(ylimit, 0), col="darkgreen")
plotProfile(ctd, xtype="CTD Oxygen (µm/kg)", ylim=c(ylimit, 0), col="darkblue")
plotProfile(ctd, xtype="Beam Attenuation (1/m)", ylim=c(ylimit, 0), col="red")
dev.off()