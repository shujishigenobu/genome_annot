#scaffold_120EVMgene365656367594.+.ID=evm.TU.scaffold_120.19;Name=EVM%20prediction%20scaffold_120.19
#scaffold_120EVMmRNA365656367594.+.ID=evm.model.scaffold_120.19;Parent=evm.TU.scaffold_120.19
#scaffold_120EVMexon365656365665.+.ID=evm.model.scaffold_120.19.exon1;Parent=evm.model.scaffold_120.19
#scaffold_120EVMCDS365656365665.+0ID=cds.evm.model.scaffold_120.19;Parent=evm.model.scaffold_120.19
#scaffold_120EVMexon365882366016.+.ID=evm.model.scaffold_120.19.exon2;Parent=evm.model.scaffold_120.19
#scaffold_120EVMCDS365882366016.+2ID=cds.evm.model.scaffold_120.19;Parent=evm.model.scaffold_120.19

#scaffold_362stdinexon205529205672.+.gene_id "CjOr1004"; transcript_id "CjOr1004"; exon_number "1"; exon_id "CjOr1004.1";
#scaffold_362stdinCDS205529205672.+0gene_id "CjOr1004"; transcript_id "CjOr1004"; exon_number "1"; exon_id "CjOr1004.1";
#scaffold_362stdinexon206036206387.+.gene_id "CjOr1004"; transcript_id "CjOr1004"; exon_number "2"; exon_id "CjOr1004.2";
#scaffold_362stdinCDS206036206387.+0gene_id "CjOr1004"; transcript_id "CjOr1004"; exon_number "2"; exon_id "CjOr1004.2";

ARGF.each do |l|
#  puts l
  a = l.chomp.split(/\t/)
  b = a.dup

  case a[2]
  when "gene"
    gid = /ID\=(.+?);/.match(a[8])[1]
    b[8] = "gene_id \"#{gid}\";"
  when "mRNA"
    gid = /Parent\=(.+?)$/.match(a[8])[1]
    tid = /ID\=(.+?);/.match(a[8])[1]
    b[8] = "gene_id \"#{gid}\"; transcript_id \"#{tid}\";"
  when "exon", "CDS"
    tid = /Parent\=(.+?)$/.match(a[8])[1]
    gid = tid.sub(/model/, "TU")
    b[8] = "gene_id \"#{gid}\"; transcript_id \"#{tid}\";"
  end

  puts b.join("\t")

end
