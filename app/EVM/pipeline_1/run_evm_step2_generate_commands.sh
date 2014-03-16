~/bio/Applications/EVM_r2012-06-25/EvmUtils/write_EVM_commands.pl \
 --genome Rspe02.final.assembly.fasta \
 --weights `pwd`/weights.txt \
 --gene_predictions gene_predictions.gff3 \
 --transcript_alignments transcript_alignments.gff3 \
 --protein_alignments protein_alignments.gff3 \
 --search_long_introns 10000  \
 --re_search_intergenic 40000 \
 --output_file_name evm.out \
 --partitions partitions_list.out >  commands.list
