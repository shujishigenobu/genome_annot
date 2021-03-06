GENOME_NAME=Rspe
MODEL_NAME=EVM10

cat scaffold_*/evm.fwd.out.gff3 > evm.fwd.out.ALL.gff3
cat scaffold_*/evm.rev.out.gff3 > evm.rev.out.ALL.gff3

ruby postfix_evm_redundancy.rb evm.fwd.out.ALL.gff3 > evm.fwd.out.ALL.rmdup.gff3
ruby postfix_evm_redundancy.rb evm.rev.out.ALL.gff3 > evm.rev.out.ALL.rmdup.gff3

ruby rename.rb evm.fwd.out.ALL.rmdup.gff3 fwd >evm.fwd.out.ALL.rmdup.renamed.gff3
ruby rename.rb evm.rev.out.ALL.rmdup.gff3 rev >evm.rev.out.ALL.rmdup.renamed.gff3

cat evm.fwd.out.ALL.rmdup.renamed.gff3 evm.rev.out.ALL.rmdup.renamed.gff3 > ${GENOME_NAME}.${MODEL_NAME}.gff3

