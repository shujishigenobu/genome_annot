GENOME=../Heike2.2.final.assembly.fasta
GFF=Heike.EVM2.3.gff3
OUTBASE=Heike.EVM2.3
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

## clean fasta definition lines

mv $OUTBASE.pep $OUTBASE.pep.orig
mv $OUTBASE.cds $OUTBASE.cds.orig

ruby clean_evm_pep_deflin.rb $OUTBASE.pep.orig > $OUTBASE.pep
ruby clean_evm_pep_deflin.rb $OUTBASE.cds.orig > $OUTBASE.cds
