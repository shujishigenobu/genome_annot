GENOME=Om2.assembly.fasta
PASA_RESULT=PASA_OulmEVM3_160409_1.gene_structures_post_PASA_updates.29643.gff3
OUTBASE=Oulm2.EVM3P
EVMDIR=~/GitHub/EVidenceModeler

GFF=$OUTBASE.gff3

grep -v "^\#" $PASA_RESULT > $GFF

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

$EVMDIR/EvmUtils/gff3_file_to_proteins.pl \
  $GFF    \
  $GENOME \
  cDNA    \
  > $OUTBASE.mRNA


## clean fasta definition lines

mv $OUTBASE.pep $OUTBASE.pep.orig
mv $OUTBASE.cds $OUTBASE.cds.orig
mv $OUTBASE.mRNA $OUTBASE.mRNA.orig

ruby clean_evm_pep_deflin.rb $OUTBASE.pep.orig > $OUTBASE.pep.fa
ruby clean_evm_pep_deflin.rb $OUTBASE.cds.orig > $OUTBASE.cds.fa
ruby clean_evm_pep_deflin.rb $OUTBASE.mRNA.orig > $OUTBASE.mRNA.fa
