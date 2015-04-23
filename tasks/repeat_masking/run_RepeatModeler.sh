GENOME=Mnat_assembly_v1.0.fa
NAME=Mnat
NCPU=24
BASEDIR=~/bio/Applications/RepeatModeler

$BASEDIR/BuildDatabase -name $NAME $GENOME

$BASEDIR/RepeatModeler -database $NAME \
  -pa $NCPU \
   > run_RepeatModeler.sh.log 2>&1

