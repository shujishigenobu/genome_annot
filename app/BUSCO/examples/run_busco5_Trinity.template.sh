#!/bin/sh
# run BUSCO5

INPUT=%SEQ%

MODE=genome
# (genome | proteins | transcriptome )

LINEAGE=insecta
# popular databases:
# arthropoda bacteria eukaryota fungi insecta metazoa
# tetrapoda vertebrata

NCPU=20

OUT=`basename $INPUT`_BUSCO5_${LINEAGE}

BUSCO_DB_DIR=/home/DB/busco

busco \
  -i $INPUT \
  -o $OUT \
  -l $LINEAGE \
  -m $MODE \
  --cpu $NCPU \
  --download_path $BUSCO_DB_DIR \


#busco -i Trinity_CerNe_210501a.fasta -l insecta -o Trinity_CerNe_210501a.busco.insecta -m transcriptome --cpu 24
