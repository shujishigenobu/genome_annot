# <bed>
# GL349641        1178565 1178796 BCR2    1       -
#
# <gtf>
# GL349641        manual  CDS     1178566 1178796 .       -       .       gene_id "BCR2"; transcript_id "BCR2-RA"

bedf = ARGV[0]

File.open(bedf).each do |l|
  a = l.chomp.split(/\t/)
  puts [a[0],
        "manual",
        "CDS",
        a[1].to_i + 1,
        a[2],
        ".",
        a[5],
        ".",
        "gene_id \"#{a[3]}; transcript_id \"#{a[3]}-RA\""].join("\t")
        
end
