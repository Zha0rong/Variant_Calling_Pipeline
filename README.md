# Variant_Calling_Pipeline
 
## This is a variant calling pipeline utilizing BWA, Samtools, Freebayes and SNPEff to analyze genomic variants in COVID.

The results are in the folder SRR15660643.

The results are generated using the following command:
./Variant_Pipeline.csh Sample.1.fastq.gz Sample.2.fastq.gz Reference MN908947 SRR15660643

Arguments Fields:
1 Read 1 of Paired End Fastq File
2 Read 2 of Paired End Fastq File
3 Name of the Directory hosting reference
4 Name of the Reference in the Reference Directory
5 Name of the output folder.

In the reference folder a customized SNPeff database is generated using NCBI genome MN908947.

