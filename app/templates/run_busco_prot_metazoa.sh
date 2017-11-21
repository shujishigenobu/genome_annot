
INPUT=../PLEWA02_ORF.pep.fa
MODE=prot
LINEAGE=metazoa_odb9
NCPU=12

OUT=`basename $INPUT`_BUSCO_${LINEAGE}

BUSCO_APP_DIR=~/bio/applications/busco
BUSCO_DB_DIR=/home/DB/BUSCO/v2

python $BUSCO_APP_DIR/scripts/run_BUSCO.py \
  -i $INPUT \
  -o $OUT \
  -l $BUSCO_DB_DIR/$LINEAGE \
  -m $MODE \
  -c $NCPU \



