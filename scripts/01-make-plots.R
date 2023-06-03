#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
library(oce)

#read in CTD file
d <- read.csv(args[1], sep=',')
#remove null values
d[d==-999] <- NA

#read in metadata file
mdata <- read.csv(args[5], sep='\t', header=TRUE)
#remove null values
mdata[mdata==-999] <- NA
dnaconc <- mdata[["DNA.concentration.ng.uL"]]
eukfrac <- mdata[["Eukaryotic_Fraction_from_Trimmed_Sequences_.18S.16S.18S."]]
nitrate <- mdata[["Nitrate.umol.kg"]]

#transform metadata into another CTD object so R-oce can understand how to plot it
salinity.bottle <- mdata[["Salinity.psu"]]
temperature.bottle <- mdata[["Temperature.degrees.Celsius"]]
pressure.bottle <- mdata[["Pressure.decibars"]]
mdata <- as.ctd(salinity.bottle, temperature.bottle, pressure.bottle)
#add additional data to CTD object
mdata <- oceSetData(mdata, '[DNA] (ng/µL)', value=dnaconc)
mdata <- oceSetData(mdata, 'Fraction 18S SSU rRNA', value=eukfrac)
mdata <- oceSetData(mdata, 'Nitrate (µm/kg)', value=nitrate)

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
ctd <- oceSetData(ctd, 'Chl. Fluorescence (0-5V DC)', value=chlfluor)
ctd <- oceSetData(ctd, 'CTD Oxygen (µm/kg)', value=ctdoxy)
ctd <- oceSetData(ctd, 'Beam Attenuation (1/m)', value=beamatt)

#calculate sigmaTheta, buoyancy frequency and add to CTD object
sigmaTheta <- swSigmaTheta(ctd)
ctd <- oceSetData(ctd, "density", value=sigmaTheta)
N2 <- swN2(ctd)
ctd <- oceSetData(ctd, "N2", value=N2)

#make plot
ylimit=as.double(args[2])
pdf(args[4], width=12,height=9)
#multiple columns
par(mfrow=c(1,9), mar=c(1,1,1,1), oma=c(10,1,1,1))
#plot templerature profile
plotProfile(ctd, xtype="temperature", ylim=c(ylimit, 0), xlim=c(0,25))
temperature <- ctd[["temperature"]]
pressure <- ctd[["pressure"]]
density <- ctd[["density"]]

#define MLD with two different methods and plot as line
for (criterion in c(0.5, 0.8)) {
    inMLD <- abs(temperature[1]-temperature) < criterion
    MLDindex <- which.min(inMLD)
    MLDpressure <- pressure[MLDindex]
    abline(h=pressure[MLDindex], lwd=2, lty="dashed")
}

#plot sigma theta with line as above
plotProfile(ctd, xtype="density", ylim=c(ylimit, 0))
for (criterion in c(0.25)) {
    inSigmaTheta <- abs(density[1]-density) < criterion
    DensityIndex <- which.min(inSigmaTheta)
    MLDpressure <- pressure[DensityIndex]
    abline(h=pressure[DensityIndex], lwd=2, lty="dashed")
}

#plot buoyant density with maximum line
plotProfile(ctd, xtype="N2", ylim=c(ylimit, 0))
N2 <- ctd[["N2"]]
maxN2 <- which.max(N2)
abline(h=pressure[maxN2], lwd=2, lty="dashed")

#plot other data sources
plotProfile(ctd, xtype="Chl. Fluorescence (0-5V DC)", ylim=c(ylimit, 0), col="darkgreen")
plotProfile(ctd, xtype="CTD Oxygen (µm/kg)", ylim=c(ylimit, 0), col="darkblue")
plotProfile(ctd, xtype="Beam Attenuation (1/m)", ylim=c(ylimit, 0), col="red")
plotProfile(mdata, xtype="Nitrate (µm/kg)", ylim=c(ylimit, 0), col="blue", type="b")
plotProfile(mdata, xtype="[DNA] (ng/µL)", ylim=c(ylimit, 0), col="orange", type="b")
plotProfile(mdata, xtype="Fraction 18S SSU rRNA", ylim=c(ylimit, 0), col="green", type="b")

#source = https://stackoverflow.com/questions/7367138/text-wrap-for-plot-titles
wrap_strings <- function(vector_of_strings,width){sapply(vector_of_strings,FUN=function(x){paste(strwrap(x,width=width), collapse="\n")})}

mtext(wrap_strings(args[3], 30), outer=TRUE, adj=0.5, padj=1, side=1)

dev.off()
