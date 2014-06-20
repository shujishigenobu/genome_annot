outdir = "gff3_by_scaffolds"

Dir["scaffold_*/evm.out.gff3"].each do |path|
#  p path
  scaff = File.dirname(path)
  outfile = "evm.out.#{scaff}.gff3"
  outpath = "#{outdir}/#{outfile}"
  File.open(outpath, "w"){|o|
    o.puts File.open(path).read
  }
end
