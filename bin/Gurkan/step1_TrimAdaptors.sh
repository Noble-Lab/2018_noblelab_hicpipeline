#!/bin/bash
#$ -cwd
#$ -l mfree=16G
#s -l disk_free=100G

#ADAPTOR SEQUENCE IS HARD CODED (BRIDGE ADAPTOR FOR DNASE HI-C)
#parameter -m to cutadapt is the minimum sequence to retain after adaptor is excised 
#-m 20 means if the sequence is shorther than 20bp after trimming, we remove that read
#parameter -u trims a fixed number bases from 5 prime or 3 prime end of the read
#-u -25 corresponds to trimming 25 bases from 3 prime end 

#Input fastq file
inputfastq=$1
#The folder to output results
outfolder=$2
filename=${inputfastq%%.fastq}
filename=${filename##*/}
outputfastq=$outfolder/$filename.filtered.fastq
outputreport=$outfolder/$filename.report
adaptorseq="AGCTGAGGGATCCCTCAGCT"
cutadapt -a $adaptorseq -m 20 -u -25 $inputfastq > $outputfastq 2> $outputreport

