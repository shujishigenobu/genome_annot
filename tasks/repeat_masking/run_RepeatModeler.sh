GENOME=Rspe02.final.assembly.fasta
NAME=Rspe
NCPU=12
BASEDIR=~/bio/Applications/RepeatModeler

$BASEDIR/BuildDatabase -name $NAME $GENOME

$BASEDIR/RepeatModeler -database $NAME \
  -pa $NCPU \
   > run_RepeatModeler.sh.log 2>&1

