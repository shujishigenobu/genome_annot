GENOME=ApL_SN190824_pseudohap2.1.fasta
DB=/home/DB/diamond/nr.dmnd
OUT=`basename $GENOME`.vs.`basename $DB`.blastx.dmnd

diamond blastx \
 --query $GENOME \
 --max-target-seqs 25 \
 --sensitive \
 --threads 48 \
 --db $DB \
 --range-culling \
 --evalue 1e-25 \
 --outfmt 6 \
 --frameshift 15  \
 --out $OUT \



