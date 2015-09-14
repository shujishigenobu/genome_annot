GENOME=Tdic_v3.fa
WEIGHT_FILE=`pwd`/weights.txt
OUT1=commands.fwd.list
OUT2=commands.rev.list

/home/shige/Projects/Aphid/Analysis/150804-Oulm_genome_annot/150811-EVM/EVidenceModeler/EvmUtils/write_EVM_commands.pl \
 --genome $GENOME \
 --weights $WEIGHT_FILE \
 --gene_predictions gene_predictions.gff3 \
 --transcript_alignments transcript_alignments.gff3 \
 --protein_alignments protein_alignments.gff3 \
 --search_long_introns 10000  \
 --re_search_intergenic 40000 \
 --output_file_name evm.fwd.out \
 --forwardStrandOnly \
 --partitions partitions_list.out >  $OUT1


/home/shige/Projects/Aphid/Analysis/150804-Oulm_genome_annot/150811-EVM/EVidenceModeler/EvmUtils/write_EVM_\
commands.pl \
 --genome $GENOME \
 --weights $WEIGHT_FILE \
 --gene_predictions gene_predictions.gff3 \
 --transcript_alignments transcript_alignments.gff3 \
 --protein_alignments protein_alignments.gff3 \
 --search_long_introns 10000  \
 --re_search_intergenic 40000 \
 --output_file_name evm.rev.out \
 --reverseStrandOnly \
 --partitions partitions_list.out >  $OUT2


#--forwardStrandOnly
#--reverseStrandOnly