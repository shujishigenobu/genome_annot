#scaffold_0      EVM     gene    583     82865   .       +       .       ID=evm.TU.scaffold_0.1;Name=EVM%20prediction%20scaffold_0.1
#scaffold_0      EVM     mRNA    583     82865   .       +       .       ID=evm.model.scaffold_0.1;Parent=evm.TU.scaffold_0.1
#scaffold_0      EVM     exon    583     685     .       +       .       ID=evm.model.scaffold_0.1.exon1;Parent=evm.model.scaffold_0.1
#scaffold_0      EVM     CDS     583     685     .       +       1       ID=cds.evm.model.scaffold_0.1;Parent=evm.model.scaffold_0.11

# evm.model.scaffold_0.4

# ID=evm.model.scaffold_0.1.exon1;Parent=evm.model.scaffold_0.1

file1 = ARGV[0] #gff
file2 = ARGV[1] #passed models as a table
#evm.out.combined.gff3 good_model.passed_scaffold034.txt

ids_passed = {}
File.open(file2).each do |l|
  a = l.chomp.split(/\t/)[0]
  ids_passed[a] = true
end

#p ids_passed

File.open(file1).each do |l|
  a = l.chomp.split(/\t/)
  if a[2] == "mRNA"
    name = /ID=(.+?)[;\s]/.match(a[8])[1].strip
    puts l if ids_passed[name]
#    p a
  elsif a[2] == "CDS"
    name = /Parent=(.+)/.match(a[8])[1].strip
    if ids_passed[name]
      puts l
    end
  end
end
