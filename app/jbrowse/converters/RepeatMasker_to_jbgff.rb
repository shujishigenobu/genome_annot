#GL349621        RepeatMasker    similarity      1       792      8.7    -       .       Target "Motif:rnd-3_family-403" 133 1496
#GL349621        RepeatMasker    similarity      1763    1789     3.9    +       .       Target "Motif:(TCAG)n" 1 29
#GL349621        RepeatMasker    similarity      2050    2236    16.9    +       .       Target "Motif:rnd-5_family-2266" 378 524

counter = 0
File.open(ARGV[0]).each do |l|
  next if /^\#/.match(l)
  a = l.chomp.split(/\t/, -1)
  b = a.dup
  id = "RM#{counter+=1}"
  name = /Target\s+\"Motif:(.+?)\"\s/.match(a[-1])[1]
  b[-1] = "ID=#{id};Name=#{name}"
  puts b.join("\t")
end
