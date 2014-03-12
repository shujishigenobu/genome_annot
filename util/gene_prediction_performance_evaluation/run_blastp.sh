#!/bin/sh

QUERY=../ORF_Rspe_Hay.pep
DB=/home/DB/public/processed/OrthoDB/OrthoDB7/blastdb/PHUMA.Pediculus_humanus.fas
OUTF=`basename $QUERY`.vs.`basename $DB`.blastp.fmt7c.txt

NCPU=8
EVALUE=1.0e-5

FORMAT="7 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen"
 
blastp -query $QUERY \
 -db  $DB \
 -evalue $EVALUE \
 -num_threads $NCPU \
 -soft_masking yes  \
 -seg yes \
 -outfmt "$FORMAT" \
 -max_target_seqs 5 \
 -out $OUTF \

 touch $OUTF.finished
