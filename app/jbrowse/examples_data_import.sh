bin/flatfile-to-json.pl --gff data_source/scipio.ZnevOGS.gff3 --trackLabel Znev_prot --trackType HTMLFeatures --className generic_parent --subfeatureClasses '{"match_part": "exon"}'

bin/flatfile-to-json.pl --gff data_source/AphidBase_OGS2.1_withCDS.gff3 --trackType CanvasFeatures --trackLabel AphidBase_OGS

bin/flatfile-to-json.pl --bed data_source/Rspe-Mnat.target.syn.net.bed --trackLabel lastz-net2_Mnat --trackType HTMLFeatures --className feature

bin/generate-names.pl -v

bin/prepare-refseqs.pl --fasta data_source/Cj4.genome.fa

bin/remove-track.pl --delete --trackLabel DMELA.p2g

# jbrowse feature glyphs
See
http://botryllus.stanford.edu/botryllusgenome/browse/docs/featureglyphs.html

