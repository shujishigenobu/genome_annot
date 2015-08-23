# input = output.cegma.gff
# (ex)
#scaffold_228    cegma   First   192734  192736  -3.93   -       0       KOG0002.4
#scaffold_228    cegma   Exon    192734  192736  -3.93   -       .       KOG0002.4
#scaffold_228    cegma   Internal        192514  192617  48.52   -       0       KOG0002.4
#scaffold_228    cegma   Exon    192514  192617  48.52   -       .       KOG0002.4
#scaffold_228    cegma   Terminal        191308  191356  24.66   -       1       KOG0002.4
#scaffold_228    cegma   Exon    191308  191356  24.66   -       .       KOG0002.4
#scaffold_13     cegma   First   1975392 1975581 111.30  +       0       KOG0003.3
#scaffold_13     cegma   Exon    1975392 1975581 111.30  +       .       KOG0003.3
#
# output
#scaffold_228    cegma   mRNA    191308  192736  .       -       .       ID=KOG0002.4.0
#scaffold_228    cegma   Exon    192734  192736  -3.93   -       .       Parent=KOG0002.4.0
#scaffold_228    cegma   Exon    192514  192617  48.52   -       .       Parent=KOG0002.4.0
#scaffold_228    cegma   Exon    191308  191356  24.66   -       .       Parent=KOG0002.4.0
#scaffold_13     cegma   mRNA    1975392 1976826 .       +       .       ID=KOG0003.3.1
#scaffold_13     cegma   Exon    1975392 1975581 111.30  +       .       Parent=KOG0003.3.1

genes = {}
File.open(ARGV[0]).each do |l|
  a = l.chomp.split(/\t/)
  gname = a[8]
  unless genes.has_key?(gname)
    genes[gname] = []
  end
  if a[2] == "Exon"
    genes[gname] << a
  end

end

genes.each do |gname, exons|
  exon_position_pairs = exons.map{|e| [e[3].to_i, e[4].to_i]}
  tmp_ary = exon_position_pairs.flatten.sort
  left = tmp_ary.first
  right = tmp_ary.last
  mrna = exons[0].dup
  mrna[2] = "mRNA"
  mrna[3] = left
  mrna[4] = right
  mrna[8] = "ID=#{gname}"
  mrna[5] = "."
  puts mrna.join("\t")

  exons.each do |e|
    e2 = e.dup
    e2[8] = "Parent=#{gname}"
    puts e2.join("\t")
  end
end
