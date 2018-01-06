LIST=mergelist_171224.txt
#mergelist.txt

NCPU=16
OUT=stringtie_merged.gtf

stringtie --merge \
  -p $NCPU \
  -o $OUT \
   $LIST
