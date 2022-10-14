#!/bin/bash -i
conda activate r-oce

for station in `tail -n+2 input/P16N_metadata.tsv  | cut -f1 | cut -f1-2 -d- | sort | uniq`; do
       
	echo $station

done
