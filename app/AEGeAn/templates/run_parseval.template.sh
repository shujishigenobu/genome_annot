REF=RsGM8.noBlankLine.gff3
PRED=RsGM8.1.noBlankLine.gff3
OUT=RsGM8vs8.1.parseval.out
REF_LABEL=v8.0
PRED_LABEL=v8.1

#parseval -o $OUT -x $REF_LABEL -y $PRED_LABEL  $REF $PRED
parseval -o $OUT.nogff -x $REF_LABEL -y $PRED_LABEL --nogff3 $REF $PRED

OUT=RsGM8vs8.1.parseval_out_html
#parseval -f html -o $OUT -x $REF_LABEL -y $PRED_LABEL $REF $PRED


