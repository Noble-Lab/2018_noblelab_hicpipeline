#!/bin/bash -vx
#$ -cwd
#$ -l mfree=8G
#s -l disk_free=10G

#Three arguments: 
#the input fastq file
infile=$1

#output folder to dump all alignment files
outFolder=$2

#the folder that contains bwa index
#bwa index for the genome to align against
#to create an index, see http://bio-bwa.sourceforge.net/bwa.shtml
index=$3

#number of mismatches allowed
nMismatches=$4

qualityThresh=30

source /etc/profile.d/modules.sh
module load modules modules-init modules-gs modules-noble
#used a different bwa version here
module load bwa/0.7.3 samtools/1.3
hostname
#LC_COLLATE=C; LC_ALL=C ; LANG=C ; export LC_ALL LANG
#echo "Environment: LC_COLLATE=$LC_COLLATE, LC_ALL = $LC_ALL, LANG = $LANG " 

filename=${infile##*/}
filename=${filename%.fastq}

mkdir -p $outFolder


in1=$1
#Generate outname
#out1=$outFolder/$filename.sai
# bwa mem
out1=$outFolder/$filename.bam

##########################################
if [[ ! $in1 == *sai ]]
then
	date
	echo starting aligning
#	bwa aln -t 8 $index $infile > $out1
#	bwa mem -M -t 8 $index $infile > $out1
	date
	echo finished mapping
fi

##################################
	
#in1=$infile
#in2=$out1
#out1=$outFolder/$filename.sam

#date
#echo making sam from $in1 $in2
#bwa samse -n 5 $index $in2 $in1 > $out1
#date
#echo finished samming
################################################

in1=$out1
out1=$outFolder/$filename.sorted
out2=$outFolder/$filename.mapped


echo starting generating mapped	reads
# filter for unique mapping, minimum mapping quality, and maximum number of mismatches

# for BWA-MEM
cat $in1 | samtools view -q $qualityThresh -F 4 -F 256 - | awk '{split($1,id,"#"); print id[1]"\t"$2"\t"$3"\t"$4"\t"$10}' | sort -k 1,1 > $out1

# for BWA-ALN
#cat $in1 | samtools view -S -F 4 - | awk  -v qual="$qualityThresh" -v mis="$nMismatches"  '($14=="X0:i:1" || $15=="X0:i:1") &&  $5>=qual && $12=="XT:A:U" {split($1,id,"#"); split($13,editDistField,":"); if (editDistField[1] == "NM" && editDistField[3] <= mis) {print id[1]"\t"$2"\t"$3"\t"$4"\t"$10}}' | sort -k 1,1 > $out1

#if you want to keep mismatches, do this instead of the above line
############################################################################
#echo extracting multimaps
#cat $in1 | samtools view -S -F 4 - | sort -k 1,1 > $out1
#python ./extract_multimaps.py $out1 $out2 ${out2}_extras
############################################################################

#If desired outputted files can be zipped here
#gzip -f $out1 $outFolder/$filename.sam $outfolder/$filename.sai
date
echo finished generating mapped reads

