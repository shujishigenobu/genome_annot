CONF=pasa.alignAssembly.config
GENOME=Om2.assembly.fasta
TRANSCRIPT=Trinity_Oulm_150304k2.fa
NCPU=20


$PASAHOME/scripts/Launch_PASA_pipeline.pl \
 -c pasa.alignAssembly.config -C -r -R -g $GENOME \
 -t $TRANSCRIPT.clean -T -u $TRANSCRIPT \
 --ALIGNERS gmap \
 --CPU $NCPU 




