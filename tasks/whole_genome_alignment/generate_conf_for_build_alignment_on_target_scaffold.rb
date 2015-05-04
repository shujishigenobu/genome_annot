synteny_file = "target.syn.net.tab3"
size_file = "Rspe02.sizes"
synteny_blocks = []
File.open(synteny_file).each do |l|
  a = l.chomp.split(/\t/, -1)
  synteny_blocks << a if a[-1] != ""
end

synteny_blocks_by_scaffold = {}

synteny_blocks.each do |bk|
  unless synteny_blocks_by_scaffold.has_key?(bk[0])
    synteny_blocks_by_scaffold[bk[0]] = []
  end
  synteny_blocks_by_scaffold[bk[0]] << bk
end
p synteny_blocks_by_scaffold.keys.size

scaffold_size = {}
File.open(size_file).each do |l|
  a = l.chomp.split(/\t/)
  scaffold_size[a[0]] = a[1].to_i
end

template = <<"EOS"
\#\# conf
scaffold: %SCAFFOLD%
length: %SIZE%
mfa_dir: lagan_outputs
scaffold_fasta: ../../../DB/blastdb/Rspe02.final.assembly.fasta
aligned_query_name: %SCAFFOLD%.Znev
outfile: %SCAFFOLD%.Rspe-Znev.mfa
\#\# end conf
\#\# start synteny data
EOS


synteny_blocks_by_scaffold.keys.sort.each do |s|
  scriptconf = template.gsub(/%SCAFFOLD%/, s)
  scriptconf = scriptconf.gsub(/%SIZE%/, scaffold_size[s].to_s)

  scriptconf_file = "#{s}.build_alignment_on_target_scaffold.conf"
  File.open(scriptconf_file, "w"){|o|
    o.puts scriptconf
    synteny_blocks_by_scaffold[s].each do |bk|
      o.puts bk.join("\t")
    end
    o.puts "end synteny data"
  }

end

