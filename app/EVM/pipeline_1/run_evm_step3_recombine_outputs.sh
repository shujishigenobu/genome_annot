GENOME=Rspe02.final.assembly.fasta

~/bio/Applications/EVM_r2012-06-25/EvmUtils/recombine_EVM_partial_outputs.pl \
 --partitions partitions_list.out \
 --output_file_name evm.out

~/bio/Applications/EVM_r2012-06-25/EvmUtils/convert_EVM_outputs_to_GFF3.pl \
 --partitions partitions_list.out \
 --output evm.out \
  --genome $GENOME
