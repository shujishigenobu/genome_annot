#!/bin/sh

INPUT=Acyrthosiphon_pisum_ApL_ApLGA1.genome.fasta

MODE=genome
# (genome | proteins | transcriptome )

LINEAGE=insecta_odb9
# databases
#arthropoda_odb9
#bacteria_odb9
#eukaryota_odb9
#fungi_odb9
#insecta_odb9
#metazoa_odb9
#tetrapoda_odb9
#vertebrata_odb9

NCPU=20

OUT=`basename $INPUT`_BUSCO_${LINEAGE}

BUSCO_APP_DIR=~/bio/applications/busco
BUSCO_DB_DIR=/home/DB/BUSCO/v2

python $BUSCO_APP_DIR/scripts/run_BUSCO.py \
  -i $INPUT \
  -o $OUT \
  -l $BUSCO_DB_DIR/$LINEAGE \
  -m $MODE \
  -c $NCPU \



