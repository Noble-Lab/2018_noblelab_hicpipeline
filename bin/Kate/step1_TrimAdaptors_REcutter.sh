#!/bin/bash
#$ -cwd
#$ -l mfree=16G
#s -l disk_free=100G

# this script is for trimming data from a restriction enzyme-derived library (ie no bridge adapter)

source ~/myenv.sh #kate's environment

#Input fastq file
inputfastq=$1
#The folder to output results
outprefix=$2
# length to trim from the 5' end of the sequence
trimlength5=$3
# length to trim from the 3' end of the sequence
trimlength3=$4
# minimum read length required after trimming
minlength=20

# extract filename from input
#filename=${inputfastq%%.fastq}
#filename=${filename%%.fq}
#filename=${filename%%.fq.gz}
#filename=${filename%%.fastq.gz}
#filename=${filename##*/}

outputfastq=$outprefix.trimmed.fastq
outputreport=$outprefix.report

#truseq="GATCGGAAGAGCACACGTCTGAACTCCAGTCAC"

echo "cutadapt -m $minlength -u $trimlength5 -u -$trimlength3 $inputfastq > $outputfastq 2> $outputreport"
cutadapt -m $minlength -u $trimlength5 -u -$trimlength3 $inputfastq > $outputfastq 2> $outputreport
gzip $outputfastq
