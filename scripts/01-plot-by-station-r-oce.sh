#!/bin/bash -i
conda activate r-oce

mkdir -p CTD-plots

infile=input/P16S_metadata.tsv

for station in `tail -n+2 $infile | cut -f1 | cut -f1-2 -d- | sort | uniq`; do
       
	stationNo=`echo $station | cut -f2 -d- | sed 's/S//' | sed 's/^0//g'`
	paddedStationNo=`printf  "%05d" ${stationNo#0}`
	maxDepth=`grep $station $infile | cut -f9 | sort -gr | head -n1`

	latTSV=`grep $station $infile | cut -f7 | sort | uniq`
	lonTSV=`grep $station $infile | cut -f6 | sort | uniq`

	#add loop to account for multiple CTD casts per station
	for inputFile in `ls P16S/33RR200501_$paddedStationNo*stripped.csv`; do

		filestem=`basename $inputFile .stripped.csv`
		dirname=`dirname $inputFile`
	        latCSV=`grep "LATITUDE =" $dirname/$filestem.csv | cut -f2 -d\= | sed 's/ //g'`
        	lonCSV=`grep "LONGITUDE =" $dirname/$filestem.csv | cut -f2 -d\= | sed 's/ //g'`
	
		outfile=CTD-plots/$station.$filestem.CTDprofile.pdf

		./scripts/01-make-plots.R $inputFile $maxDepth "CTD Profile for $station (ASVlatlong=$latTSV,$lonTSV; CTDlatlong=$latTSV,$lonTSV)" $outfile
	
	done 

done

infile=input/P16N_metadata.tsv

for station in `tail -n+2 $infile | cut -f1 | cut -f1-2 -d- | sort | uniq`; do

        stationNo=`echo $station | cut -f2 -d- | sed 's/S//'`
        paddedStationNo=`printf  "%05d" ${stationNo#0}` #strip leading zero to prevent being interpreted as octal: https://stackoverflow.com/questions/8078167/printf-in-bash-09-and-08-are-invalid-numbers-07-and-06-are-fine
        maxDepth=`grep $station $infile | cut -f9 | sort -gr | head -n1`

        latTSV=`grep $station $infile | cut -f7 | sort | uniq`
        lonTSV=`grep $station $infile | cut -f6 | sort | uniq`

        #add loop to account for multiple CTD casts per station
        for inputFile in `ls P16N/325020060213_$paddedStationNo*stripped.csv`; do

                filestem=`basename $inputFile .stripped.csv`
                dirname=`dirname $inputFile`
                latCSV=`grep "LATITUDE =" $dirname/$filestem.csv | cut -f2 -d\= | sed 's/ //g'`
                lonCSV=`grep "LONGITUDE =" $dirname/$filestem.csv | cut -f2 -d\= | sed 's/ //g'`

                outfile=CTD-plots/$station.$filestem.CTDprofile.pdf

                ./scripts/01-make-plots.P16N.R $inputFile $maxDepth "CTD Profile for $station (ASVlatlong=$latTSV,$lonTSV; CTDlatlong=$latTSV,$lonTSV)" $outfile

        done

done

