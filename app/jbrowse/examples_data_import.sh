bin/flatfile-to-json.pl --gff data_source/scipio.ZnevOGS.gff3 --trackLabel Znev_prot --trackType HTMLFeatures --className generic_parent --subfeatureClasses '{"match_part": "exon"}'

bin/flatfile-to-json.pl --gff data_source/AphidBase_OGS2.1_withCDS.gff3 --trackType CanvasFeatures --trackLabel AphidBase_OGS

bin/generate-names.pl -v

bin/prepare-refseqs.pl --fasta data_source/Cj4.genome.fa

bin/remove-track.pl --delete --trackLabel DMELA.p2g