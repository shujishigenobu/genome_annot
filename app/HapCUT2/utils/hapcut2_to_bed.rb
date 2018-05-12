hap2f = (ARGV[0] || "ApL.hologenome.170808.pilonVariants.rmDUP.HAPCUT2.out")

#BLOCK: offset: 303 len: 24 phased: 23 SPAN: 195 fragments 13

$/ = "********"
File.open(hap2f).each do |rec|
  rec.strip!
  lines = rec.split(/\n/)
  header = lines.shift
  lines.pop
  m = /BLOCK: offset: (\d+) len: (\d+) phased: (\d+) SPAN: (\d+) fragments (\d+)/.match(header)
#  p header
  offset = m[1].to_i; len = m[2].to_i; phased = m[3].to_i; span = m[4].to_i; fragments = m[5].to_i;

  chromosomes = []
  positions = []
  lines.each do |l|
    a = l.chomp.split(/\t/)
    chromosomes << a[3]
    positions << a[4].to_i
  end
  chr = chromosomes[0]
  positions_sorted = positions.sort
  from = positions_sorted.first
  to = positions_sorted.last
  name = "BL#{offset}"

  puts [chr, from, to, name, fragments, "."].join("\t")

end
