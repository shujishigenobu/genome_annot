## step 1

for f in *psl; do 
  axtChain $f ../LSR ../ApL stdout -linearGap=medium -minScore=5000 -psl | 
  chainAntiRepeat ../LSR ../ApL stdin $f.chain;
done


## step 2

chainMergeSort *chain > all.chain
chainPreNet all.chain ../LSR.sizes ../ApL.sizes all.pre.chain

## step 3

chainNet all.pre.chain -minSpace=100 minScore=400000 ../LSR.sizes ../ApL.sizes target.net query.net

## step 4

netSyntenic target.net target.syn.net
netSyntenic query.net query.syn.net

