GENOME=genome.fa
GFF=Dnox.EVM2.gff3
OUTBASE=Dnox.EVM2
EVMDIR=~/GitHub/EVidenceModeler

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
