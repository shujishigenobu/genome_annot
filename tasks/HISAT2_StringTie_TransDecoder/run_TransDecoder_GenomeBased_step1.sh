GENOME=hormaphis_cornu_26Sep2017_PoQx8.fasta
GTF=stringtie_merged.gtf
OUTFASTA=`basename $GTF .gtf`.transcripts.fasta
OUTGFF3=`basename $GTF .gtf`.gff3

TDDIR=~/bio/applications/TransDecoder-v5.0.2

$TDDIR/util/gtf_genome_to_cdna_fasta.pl  $GTF $GENOME > $OUTFASTA

$TDDIR/util/gtf_to_alignment_gff3.pl $GTF > $OUTGFF3



