source ~/.bashrc
 
GENOME=%FASTA%
#Rspe02.final.assembly.hmask.fa
MODEL=fly
OUTF=augustus.abinitio.noTrain.modelFly.`basename $GENOME .fasta`.gff
 
augustus \
 --species=$MODEL \
 $GENOME \
 > $OUTF