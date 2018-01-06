SCRDIR=~/MyBitbucket/okorf2

BASENAME=stringtie_merged.transcripts.fasta.transdecoder
TASSEMBLY=stringtie_merged.transcripts.fasta
OUTBASE=ORF_HisatStringtieTD

sh $SCRDIR/run_cdhit_cds_local_p2.sh $BASENAME.cds $OUTBASE.cds.fa.cdhit97

fast ids $OUTBASE.cds.fa.cdhit97 > $OUTBASE.cds.fa.cdhit97.ids

ruby $SCRDIR/get_gff_entries_from_idlist.rb $BASENAME.gff3 $OUTBASE.cds.fa.cdhit97.ids > $OUTBASE.rmdup.gff3

GFF=$OUTBASE.rmdup.gff3

perl $SCRDIR/util/gff3_file_to_bed.pl $GFF > `basename $GFF .gff3`.bed

perl $SCRDIR/util/gff3_file_to_proteins.pl $GFF $TASSEMBLY prot > `basename $GFF .gff3`.pep.fa

perl $SCRDIR/util/gff3_file_to_proteins.pl $GFF $TASSEMBLY CDS > `basename $GFF .gff3`.cds.fa
