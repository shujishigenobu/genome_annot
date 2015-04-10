RepeatMasker=/home/shige/bio/Applications/maker/exe/RepeatMasker/RepeatMasker
RepeatLibrary=/home/shige/Projects/n11723-MiuraG/Analysis/150119-RspeGenomeWideCompara/150410-Mnat_RepeatMasker/RM_4765.FriApr100210372015/consensi.fa.classified

SEQ=Mnat_assembly_v1.0.fa
#SEQ=test.fasta
NCPU=30

$RepeatMasker \
 -lib $RepeatLibrary \
 -pa $NCPU \
 -gff \
 -xsmall \
 $SEQ \
 1>$0.log 2>&1 \
