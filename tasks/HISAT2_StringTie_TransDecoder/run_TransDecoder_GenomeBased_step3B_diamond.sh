#=== conf ===
NCPU=16
#===
 
QUERY=stringtie_merged.transcripts.fasta.transdecoder_dir/longest_orfs.pep
DB=/home/shige/Projects/Firefly/Analysis/171020-blobtools/uniprot_ref_proteomes.diamond
TASK=blastp
EVALUE=1.0e-5
OUTF=`basename $QUERY`.vs.`basename $DB`.${TASK}.dmnd.out
FORMAT=6
 
diamond $TASK \
 --query $QUERY \
 --db  $DB \
 --evalue $EVALUE \
 --threads $NCPU \
 --outfmt $FORMAT \
 --max-target-seqs 1 \
 --out $OUTF \


# --sensitive \
