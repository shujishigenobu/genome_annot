GENOME=genome.fa
EVMDIR=~/GitHub/EVidenceModeler
PARTITION_FILE=partitions_list.out

$EVMDIR/EvmUtils/recombine_EVM_partial_outputs.pl \
 --partitions $PARTITION_FILE \
 --output_file_name evm.fwd.out

$EVMDIR/EvmUtils/convert_EVM_outputs_to_GFF3.pl \
 --partitions $PARTITION_FILE \
 --output evm.fwd.out \
  --genome $GENOME
