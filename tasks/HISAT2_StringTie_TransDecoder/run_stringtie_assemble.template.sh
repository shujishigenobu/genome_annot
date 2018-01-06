
BAM=%BAM%
NAME=%NAME%
NCPU=8
OUT=$NAME.gtf

stringtie \
  -p $NCPU \
  -o $OUT \
   $BAM
