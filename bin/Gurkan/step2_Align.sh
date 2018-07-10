#!/bin/bash
#$ -cwd
#$ -l mfree=16G
#s -l disk_free=100G

#Three arguments: 
#the input fastq file
infile=$1

#output folder to dump all alignment files
outFolder=$2

#the folder that contains bwa index
#bwa index for the genome to align against
#to create an index, see http://bio-bwa.sourceforge.net/bwa.shtml
bwaindex=$3


source /etc/profile.d/modules.sh
module load modules modules-init modules-gs modules-noble
#used a different bwa version here
module load bwa/0.7.3 samtools/0.1.18
hostname
#LC_COLLATE=C; LC_ALL=C ; LANG=C ; export LC_ALL LANG
#echo "Environment: LC_COLLATE=$LC_COLLATE, LC_ALL = $LC_ALL, LANG = $LANG " 

filename=${infile##*/}
filename=${filename%.fastq}
#Put a folder maker here


in1=$1
#Generate outname
out1=$outFolder/$filename.sai

if [[ ! $in1 == *sai ]]
then
	date
	echo starting aligning
	bwa aln -t 8 $index $infile > $out1
	#echo "bwa aln -t 8 $index $infile > $out1"
	date
	echo finished mapping
fi
	
in1=$infile
in2=$out1
out1=$outFolder/$filename.sam
	
date
echo making sam from $in1 $in2
bwa samse $index $in2 $in1 > $out1
date
echo finished samming

in1=$out1
out1=$outFolder/$filename.mapped


echo starting generating mapped	reads
#OUTPUT MAPPED READS FROM SAM FILE
cat $in1 | samtools view -S -F 4 - | awk '($14=="X0:i:1" || $15=="X0:i:1") &&  $5>=30 && $12=="XT:A:U" {split($1,id,"#"); split($13,editDistField,":"); if (editDistField[1] == "NM" && editDistField[3] <= 3) {print id[1]"\t"$2"\t"$3"\t"$4"\t"$10}}' | sort -k 1,1 > $out1
#If desired outputted files can be zipped here
#gzip -f $out1
date
echo finished generating mapped reads

