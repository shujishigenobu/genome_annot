BLASTDB=/home/DB/blast/v5

export BLASTDB

DB=nt_v5
GENOME=ApL_SN190824_pseudohap2.1.fasta
TASK=megablast
OUTF=`basename $GENOME`.vs.nt.$TASK.out5.txt

blastn \
 -task $TASK \
 -query $GENOME \
 -db $DB \
 -outfmt '6 std qlen slen staxids sscinames sskingdom stitle' \
 -max_target_seqs 10  \
 -max_hsps  10 \
 -num_threads 32 \
 -evalue 1e-25 \
 -culling_limit 3 \
 -out $OUTF

