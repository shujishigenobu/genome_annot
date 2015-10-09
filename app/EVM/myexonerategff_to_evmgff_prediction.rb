ARGF.each do |l|
  a = l.chomp.split(/\t/)
  if a[2] == "match"
    id = /^ID\=(.+)?/.match(a[8])[1]
    b = a.dup
    b[2] = "gene"
    b[8] = "ID=#{id};"
    puts b.join("\t")
    c = b.dup
    c[2] = "mRNA"
    id2 = "#{id}.t"
    c[8] = "ID=#{id2}; Parent=#{id}"
    puts c.join("\t")
  elsif a[2] == "match_part"
    gid = /^Parent\=(.+)?/.match(a[8])[1]
    tid = "#{gid}.t"
    id = "#{gid}.cds"
    d = a.dup
    d[2] = "CDS"
    d[8] = "ID=#{id}; Parent=#{tid}"
    puts d.join("\t")
  end
end
