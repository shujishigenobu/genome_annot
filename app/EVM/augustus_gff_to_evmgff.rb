#(example imput)
## start gene g3
#scaffold_999    AUGUSTUS        gene    45775   66691   0.39    -       .       g3
#scaffold_999    AUGUSTUS        transcript      45775   66691   0.39    -       .       g3.t1
#scaffold_999    AUGUSTUS        stop_codon      45775   45777   .       -       0       transcript_id "g3.t1"; gene_id "g3";
#scaffold_999    AUGUSTUS        intron  45964   52854   0.9     -       .       transcript_id "g3.t1"; gene_id "g3";
#scaffold_999    AUGUSTUS        intron  53316   54336   0.57    -       .       transcript_id "g3.t1"; gene_id "g3";
#scaffold_999    AUGUSTUS        intron  54487   64139   0.46    -       .       transcript_id "g3.t1"; gene_id "g3";
#scaffold_999    AUGUSTUS        intron  64233   66612   0.84    -       .       transcript_id "g3.t1"; gene_id "g3";
#scaffold_999    AUGUSTUS        CDS     45775   45963   0.92    -       0       transcript_id "g3.t1"; gene_id "g3";
#scaffold_999    AUGUSTUS        CDS     52855   53315   0.55    -       2       transcript_id "g3.t1"; gene_id "g3";
#scaffold_999    AUGUSTUS        CDS     54337   54486   0.48    -       2       transcript_id "g3.t1"; gene_id "g3";
#scaffold_999    AUGUSTUS        CDS     64140   64232   0.47    -       2       transcript_id "g3.t1"; gene_id "g3";
#scaffold_999    AUGUSTUS        CDS     66613   66691   0.85    -       0       transcript_id "g3.t1"; gene_id "g3";
#scaffold_999    AUGUSTUS        start_codon     66689   66691   .       -       0       transcript_id "g3.t1"; gene_id "g3";

inputf = ARGV[0]
source = ARGV[1]

exon_i = 0
File.open(ARGV[0]).each do |l|
  a = l.chomp.split(/\t/)
  b = a.dup
  case a[2]
  when 'gene'
    name = "#{a[0]}.#{a[8]}"
    attr = "ID=#{name}"
    b[8] = attr
    puts b.join("\t")
  when 'transcript'
    name = "#{a[0]}.#{a[8]}"
    parent = name.sub(/\.t\d+/, '')
    attr = "ID=#{name}; Parent=#{parent}"
    b[8] = attr
    b[2] = "mRNA"
    puts b.join("\t")
  when 'CDS'
    m = /^transcript_id \"(.+)\"; gene_id \"(.+)\";/.match(a[8])
    parent = "#{a[0]}.#{m[1]}"
    attr = "ID=#{parent}.cds; Parent=#{parent}"
    b[8] = attr
    c = b.dup
    c[2] = "exon"
    exonname = "#{a[0]}.exon#{exon_i += 1}"
    c[8] = "ID=#{exonname}; Parent=#{parent}"
    puts c.join("\t")
    puts b.join("\t")
  else
  end


end
