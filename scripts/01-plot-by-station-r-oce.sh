#!/bin/bash -i
conda activate r-oce

for station in `tail -n+2 input/P16S_metadata.tsv  | cut -f1 | cut -f1-2 -d- | sort | uniq`; do
       
	stationNo=`echo $station | cut -f2 -d-`
	paddedStationNo=`printf  "%05d\n" $stationNo`
	echo $paddedStationNo
	#./scripts/01-make-plots.R P16S/33RR200501_00111_00002_ct1.stripped.csv 500 "This is a title" outfile.pdf
	echo $station

done
