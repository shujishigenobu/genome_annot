GENOME=Tdic_v3.fa
GFF=Tdic_v3.EVM2.gff3
OUTBASE=Tdic_v3.EVM2
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
