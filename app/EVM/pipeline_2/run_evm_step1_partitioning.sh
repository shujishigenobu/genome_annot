GENOME=genome.fa

EVMHOME=~/GitHub/EVidenceModeler/

$EVMHOME/EvmUtils/partition_EVM_inputs.pl \
  --genome $GENOME \
  --gene_predictions gene_predictions.gff3 \
  --transcript_alignments transcript_alignments.gff3 \
  --protein_alignments protein_alignments.gff3 \
  --segmentSize 500000 \
  --overlapSize 100000 \
  --partition_listing partitions_list.out


  