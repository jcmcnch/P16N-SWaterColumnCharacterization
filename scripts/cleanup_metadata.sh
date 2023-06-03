#!/bin/bash -i

#230603 notes for converting Yubin's output to TSV for input to plotting scripts

cd input
head -n1 ../2.20230530_P16NS_Sample_Metadata_Final.csv > P16N_metadata.tsv
grep "P16N" ../2.20230530_P16NS_Sample_Metadata_Final.csv >> P16N_metadata.tsv
sed 's/\"//g' P16N_metadata.tsv | sed 's/,/	/g' | sponge P16N_metadata.tsv

head -n1 ../2.20230530_P16NS_Sample_Metadata_Final.csv > P16S_metadata.tsv
grep "P16S" ../2.20230530_P16NS_Sample_Metadata_Final.csv >> P16S_metadata.tsv
sed 's/\"//g' P16S_metadata.tsv | sed 's/,/	/g' | sponge P16S_metadata.tsv
