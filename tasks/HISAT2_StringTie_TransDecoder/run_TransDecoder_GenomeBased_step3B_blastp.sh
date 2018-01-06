QUERY=stringtie_merged.transcripts.fasta.transdecoder_dir/longest_orfs.pep
DB=../../../Data/Acyrthosiphon_pisum/blastdb/aphidbase_2.1_pep_with_product.fasta
OUT=`basename $QUERY`.vs.`basename $DB`.blastp-fast.fmt6
NCPU=8

blastp \
   -task blastp-fast \
   -query $QUERY \
   -db $DB \
   -evalue 1.0e-5 -num_threads $NCPU -outfmt 6 -max_target_seqs 1 > $OUT
