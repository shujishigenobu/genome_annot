# start gene g1
#scaffold_999    AUGUSTUS        gene    1       23615   0.01    -       .       g1
#scaffold_999    AUGUSTUS        transcript      1       23615   0.01    -       .       g1.t1
#scaffold_999    AUGUSTUS        intron  1       14073   0.03    -       .       transcript_id "g1.t1"; gene_id "g1";
#scaffold_999    AUGUSTUS        intron  14224   15194   0.96    -       .       transcript_id "g1.t1"; gene_id "g1";
#scaffold_999    AUGUSTUS        intron  15329   16812   0.99    -       .       transcript_id "g1.t1"; gene_id "g1";
#scaffold_999    AUGUSTUS        intron  16961   19976   0.17    -       .       transcript_id "g1.t1"; gene_id "g1";
#scaffold_999    AUGUSTUS        intron  20147   21988   0.22    -       .       transcript_id "g1.t1"; gene_id "g1";
#scaffold_999    AUGUSTUS        CDS     14074   14223   0.99    -       2       transcript_id "g1.t1"; gene_id "g1";
#scaffold_999    AUGUSTUS        exon    14074   14223   .       -       .       transcript_id "g1.t1"; gene_id "g1";
#scaffold_999    AUGUSTUS        CDS     15195   15328   0.97    -       1       transcript_id "g1.t1"; gene_id "g1";

ARGF.each do |l|
  next if /^\#/.match(l)
  a = l.chomp.split(/\t/)
  b = a.dup
  chr = a[0]
  case a[2]
  when "gene"
    b[8] = "ID=#{chr}.#{a[8]}"
  when "transcript"
    b[2] = "mRNA"
    parent = a[8].split(/\./)[0]
    b[8] = "ID=#{chr}.#{a[8]}; Parent=#{chr}.#{parent}"
    when "exon", "CDS"
    parent = /transcript_id \"(.+?)\"/.match(a[8])[1]
    b[8] = "Parent=#{chr}.#{parent}"
  else
    next
  end
  puts b.join("\t")
end
