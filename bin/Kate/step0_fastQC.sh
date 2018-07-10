#!/bin/bash
#$ -cwd
#$ -l mfree=16G
#s -l disk_free=100G

# Run fastQC to get an idea of whether there are any major issues with the libraries and how much to trim

#Input fastq file
inputfastq=$1
#The folder to output results
outprefix=$2

# extract filename from input
filename=${inputfastq%%.fastq}
filename=${filename%%.fq}
filename=${filename%%.fq.gz}
filename=${filename%%.fastq.gz}
#filename=${filename##*/}

echo $filename
outdir=${outprefix}_fastqc

fastqc $inputfastq
mkdir -p $outdir
mv ${filename}_fastqc.html ${filename}_fastqc.zip $outdir

