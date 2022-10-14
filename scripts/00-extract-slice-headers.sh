#!/bin/bash -i

#NOTE: CTD data sourced from https://cchdo.ucsd.edu/

#extract csvs from zip files
#mkdir P16N ; unzip P16N_CTD_profiles_325020060213_ct1.zip ; mv *csv P16N
#mkdir P16S ; unzip P16S_CTD_profiles_33RR200501_ct1.zip ; mv *csv P16S
 
#strip off header lines that aren't needed
for item in P16S/* ; do 
	
	outfile=P16S/`basename $item .csv`.stripped.csv
	tail -n+37 $item > $outfile

done

#slice off header lines that aren't needed
for item in P16N/* ; do 

	outfile=P16N/`basename $item .csv`.stripped.csv	
	tail -n+53 $item > $outfile

done
