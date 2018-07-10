#!/bin/bash
#$ -cwd
#$ -l mfree=8G
#s -l disk_free=1G

module load modules modules-init modules-gs modules-noble
module load python/2.7.2

intfile=$1
outfile1=$2
outfile2=$3

#SIZE OF BINS TO AGGREGATE HI-C INTERACTIONS AT
#for human genome typically 1MB for lower resolutions 
# and as small as 50KB for experiments with high coverage
#Smaller genomes allow for even smaller bin sizes
binsize=$4

#the maximum distance between an aligned pair of reads
#smaller distances are indicative of self-ligation molecules
#fragments that are seperated by a distance smaller than 
#DISTANCE THRESHOLD are ignored
DISTANCETHRESHOLD=$5

#length of chromosomes for the genome we are working with
chrlengthsfile=$6


#generate the bin mid points
binfile=$intfile.$binsize.bins.bed
python ./generate_binned_midpoints.py $binsize $chrlengthsfile $binfile

MAPPABILITYTHRESHOLD=1
DISTANCETHRESHOLD=$5

python ./count_interactions_per_binned_fragPairs.py $intfile $binfile $binsize $MAPPABILITYTHRESHOLD $DISTANCETHRESHOLD $outfile1 $outfile2 
rm $binfile
