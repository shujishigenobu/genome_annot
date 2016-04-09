CONF=pasa.alignAssembly.config
GENOME=Om2.assembly.fasta
EVM=Oulm2.EVM3.gff3
TRANSCRIPT=Trinity_Oulm_150304k2.fa

#$PASAHOME/scripts/Load_Current_Gene_Annotations.dbi \
# -c $CONF -g $GENOME -P $EVM

$PASAHOME/scripts/Launch_PASA_pipeline.pl \
 -c $CONF -A -g $GENOME -t $TRANSCRIPT.clean

