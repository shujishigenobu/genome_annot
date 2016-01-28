GENOME=genome.fa
GFF=Dnox.EVM1.1.PASAupdated.gff3
OUTBASE=Dnox.EVM1.1PASA
EVMDIR=/home/shige/Projects/Aphid/Analysis/150804-Oulm_genome_annot/150811-EVM/EVidenceModeler

$EVMDIR/EvmUtils/gff3_file_to_proteins.pl \
  $GFF    \
  $GENOME \
  prot    \
  > $OUTBASE.pep


$EVMDIR/EvmUtils/gff3_file_to_proteins.pl \
  $GFF    \
  $GENOME \
  CDS     \
  > $OUTBASE.cds
