chr = ARGV[0]
left = ARGV[1]
right = ARGV[2]
cfmodel = ARGV[3]

genome_blastdb = "../../../Data/CjGenome/blast/Cj4.genome.fasta"

cmd = "blastdbcmd -db #{genome_blastdb} -entry #{chr} -range #{left}-#{right} > tmp.fa"
system cmd

cmd = "blastdbcmd -db Cflo_Ors.pep.fa -entry #{cfmodel} > #{cfmodel}.pep"
system cmd

cmd = "exonerate --model p2g  #{cfmodel}.pep tmp.fa --showtargetgff > #{cfmodel}.exo"
system cmd
