#!/bin/csh

# This script is used to call variants using bwa alignment, samtools filtering and freebayes variant calling

# This script also contains basic QC stats for the fastq, alignment statistics for variants being called.
# Three arguments are needed:
#	1	2	3	4	5
#	Fastq1_of_sample	Fastq2_of_sample	Reference_Directory	Reference_Name	output_name
# For now only paired-end fastq files are supported

set f1 = "$1"
set f2 = "$2"
set Reference_Directory = "$3"
set Reference_Name = "$4"
set output_name = "$5"
set Reference = $Reference_Directory/$Reference_Name.fasta

mkdir $output_name
mkdir $output_name/QC

fastqc -o $output_name/QC $f1 $f2
# For now the pipeline are designed for paired-end reads that will be longer than 70. So in this case bwa-mem will be used.

bwa mem $Reference $f1 $f2 > $output_name/raw.sam

samtools view -hSbo $output_name/raw.bam $output_name/raw.sam

samtools sort -o $output_name/sorted.bam $output_name/raw.bam

samtools index $output_name/sorted.bam

rm $output_name/raw.sam

samtools flagstats $output_name/sorted.bam > $QCDirectory/flagstats.txt

picard MarkDuplicates I=$output_name/sorted.bam O=$output_name/sorted.marked.bam M=$output_name/QC/Duplication.statistics.txt

freebayes -b $output_name/sorted.marked.bam -f $Reference -v $output_name/Results.vcf --ploidy 1 --min-alternate-fraction 0.5 --min-coverage 10

/opt/anaconda3/envs/cpdb/bin/snpeff -c $Reference_Directory/snpeffdatabase/snpeff.config $Reference_Name $output_name/Results.vcf > $output_name/Annotated.Results.vcf
