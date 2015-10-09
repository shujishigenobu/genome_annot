GENOME=genome.fa
EVMDIR=/home/shige/Projects/Aphid/Analysis/150804-Oulm_genome_annot/150811-EVM/EVidenceModeler
PARTITION_FILE=partitions_list.out

$EVMDIR/EvmUtils/recombine_EVM_partial_outputs.pl \
 --partitions $PARTITION_FILE \
 --output_file_name evm.fwd.out

$EVMDIR/EvmUtils/convert_EVM_outputs_to_GFF3.pl \
 --partitions $PARTITION_FILE \
 --output evm.fwd.out \
  --genome $GENOME
