## for TransDecoder > github:190730

#=== conf ===
GENOME=../../Om2.assembly.fasta
TDDIR=~/bio/applications/TransDecoder-v5.0.2
TRANSCRIPT=stringtie_merged.transcripts.fasta
NCPU=8
PFAM=longest_orfs.pep.pfam.domtblout
BLAST=longest_orfs.pep.vs.uniprot_ref_proteomes.diamond.blastp.dmnd.out
#===

$TDDIR/TransDecoder.Predict --cpu $NCPU -t $TRANSCRIPT \
  --retain_pfam_hits $PFAM \
  --retain_blastp_hits $BLAST


#TD_GFF=stringtie_merged.transcripts.fasta.transdecoder_dir/longest_orfs.gff3
#OUTF=`basename $TD_GFF .gff3`.genome.gff3

#$TD_BASE/util/cdna_alignment_orf_to_genome_orf.pl \
#  $TD_GFF \
#  transcripts.gff3 \
#  transcripts.fasta \
#  > $OUTF

