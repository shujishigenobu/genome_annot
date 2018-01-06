PFAMDB=/home/DB/Pfam/Pfam-A.hmm
NCPU=2
#QUERY=stringtie_merged.transcripts.fasta.transdecoder_dir/longest_orfs.pep
QUERY=%FASTA%
OUT=`basename $QUERY`.pfam.domtblout

hmmscan \
  --cpu $NCPU \
  --domtblout $OUT \
  $PFAMDB \
  $QUERY
