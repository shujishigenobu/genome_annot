## for TransDecoder > github:190730

#=== conf ===
TDDIR=~/bio/applications/TransDecoder-v5.0.2
TRANSCRIPT=stringtie_merged.transcripts.fasta
TRANSCRIPT_GFF=stringtie_merged.gff3
NCPU=8
#===

#$TDDIR/TransDecoder.Predict --cpu $NCPU -t $TRANSCRIPT \
#  --retain_pfam_hits $PFAM \
#  --retain_blastp_hits $BLAST


TD_GFF=ORF_HisatStringtieTD.rmdup.gff3
OUTF=`basename $TD_GFF .gff3`.genome.gff3

$TDDIR/util/cdna_alignment_orf_to_genome_orf.pl \
  $TD_GFF \
  $TRANSCRIPT_GFF \
  $TRANSCRIPT \
  > $OUTF

