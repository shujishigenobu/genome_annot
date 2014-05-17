GENOME=../../final.assembly.fasta
GFF=EVM1.evm.gff3
OUTBASE=EVM1


/home/shige/bio/Applications/EVM_r2012-06-25/EvmUtils/gff3_file_to_proteins.pl \
  $GFF    \
  $GENOME \
  prot    \
  > $OUTBASE.pep


/home/shige/bio/Applications/EVM_r2012-06-25/EvmUtils/gff3_file_to_proteins.pl \
  $GFF    \
  $GENOME \
  CDS     \
  > $OUTBASE.cds
