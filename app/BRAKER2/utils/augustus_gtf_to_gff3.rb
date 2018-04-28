gtf = ARGV[0]
File.open(gtf).each do |l|
  a = l.chomp.split(/\t/)
  b = a.dup
  case a[2]
  when "gene"
    id = a[8].strip
    b[8] = "ID=#{id}"
  when "transcript"
    m = /(g\d+)\.(t\d+)/.match(a[8])
    b[8] = "ID=#{a[8]};Parent=#{m[1]}"
    b[2] = "mRNA"
  when "CDS", "exon"
    m = /transcript_id \"(.+?)\";/.match(a[8])
    b[8] = "Parent=#{m[1]}"
  when "intron"
    next
  else
    next
  end
  puts b.join("\t")
end
