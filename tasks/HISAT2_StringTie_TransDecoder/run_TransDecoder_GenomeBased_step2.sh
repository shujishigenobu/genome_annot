## for TransDecoder > github:190730

#=== conf ===

TDDIR=~/bio/applications/TransDecoder-v5.0.2
TRANSCRIPTS=stringtie_merged.transcripts.fasta

MIN_LEN=50 #aa
#===

$TDDIR/TransDecoder.LongOrfs \
  -t $TRANSCRIPTS \
  -m $MIN_LEN

