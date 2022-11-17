#!/bin/bash -i

for station in `tail -n+2 input/P16N_metadata.tsv | cut -f1 | cut -f1-2 -d- | sort | uniq`; do

	outfile=input/P16N.$station.tsv
	head -n1 input/P16N_metadata.tsv > $outfile
        grep $station input/P16N_metadata.tsv | sort -n -k7 >> $outfile

done

for station in `tail -n+2 input/P16S_metadata.tsv | cut -f1 | cut -f1-2 -d- | sort | uniq`; do

        outfile=input/P16S.$station.tsv
        head -n1 input/P16S_metadata.tsv > $outfile
        grep $station input/P16S_metadata.tsv | sort -n -k7 >> $outfile

done
