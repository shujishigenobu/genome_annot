#!/bin/bash

#SBATCH -p medium-m5d
#SBATCH -N 1
#SBATCH -n 16


set -e
set -u
set -o pipefail

INPUT=ApL_HF.asm.bp.p_ctg.fa

MODE=genome
# (genome | proteins | transcriptome )

LINEAGE=%%LINEAGE%%
#insecta

NCPU=16

OUTF=`basename $INPUT`_BUSCO5

BUSCO_DB_DIR=/mnt/efs/shared/db/busco/v5/data

busco -i $INPUT \
    -l $LINEAGE \
    --out_path /scratch \
    -o $OUTF \
    -m $MODE \
    --download_path $BUSCO_DB_DIR \
    -c $NCPU \
    -r


rsync -avh /scratch/$OUTF ./

    
