SEQ1=%SEQ1%
SEQ2=%SEQ2%
NAME=%NAME%

#mkdir $NAME

REF=../../Data/Hormaphis/hisat2/hormaphis_cornu_26Sep2017_PoQx8
OUTBAM=${NAME}.on.`basename $REF`.hs2.bam
NCPU=8

hisat2 -p $NCPU --dta \
  -x $REF \
  -1 $SEQ1 \
  -2 $SEQ2 \
  | samtools view -bS - \
  > $OUTBAM


