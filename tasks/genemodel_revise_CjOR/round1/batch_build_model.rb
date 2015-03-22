# get_CDSlines_from_EVMgff.rb              get_exonLines_from_exonerateGFF_CfloPep.rb  gff_to_bed12.rb
# get_CDSlines_from_TophatTransdecoder.rb  get_exonLines_from_exonerateGFF.rb

inputf = ARGV[0]

File.open(inputf).each do |l|
  a = l.chomp.split
  next unless a[0]

  base_model = a[0]
  name = a[1]

  case base_model
  when /^TCONS/
    cmd = "ruby get_CDSlines_from_TophatTransdecoder.rb \"#{base_model}\" gff #{name} > #{name}.gff"
    system cmd
    cmd = "ruby get_CDSlines_from_TophatTransdecoder.rb \"#{base_model}\" bed #{name} >#{name}.bed"
    system cmd
    cmd = "ruby get_CDSlines_from_TophatTransdecoder.rb \"#{base_model}\" fasta #{name} > #{name}.cds.fa"
    system cmd

  when /^m\.\d+/
    cmd = "ruby get_exonLines_from_exonerateGFF.rb #{base_model} gff #{name} > #{name}.gff"
    system cmd
    cmd = "ruby get_exonLines_from_exonerateGFF.rb #{base_model} bed #{name} > #{name}.bed"
    system cmd
    cmd = "ruby get_exonLines_from_exonerateGFF.rb #{base_model} fasta #{name} > #{name}.cds.fa"
    system cmd
  when /^scaffold/
    cmd = "ruby get_CDSlines_from_EVMgff.rb \"#{base_model}\" gff #{name} > #{name}.gff"
    system cmd
    cmd = "ruby get_CDSlines_from_EVMgff.rb \"#{base_model}\" bed #{name} > #{name}.bed"
    system cmd
    cmd = "ruby get_CDSlines_from_EVMgff.rb \"#{base_model}\" fasta #{name} > #{name}.cds.fa"
    system cmd

  when /^Cf/
    cmd = "ruby get_exonLines_from_exonerateGFF_CfloPep.rb #{base_model} gff #{name} > #{name}.gff"
    system cmd
    cmd = "ruby get_exonLines_from_exonerateGFF_CfloPep.rb #{base_model} bed #{name} > #{name}.bed"
    system cmd
    cmd = "ruby get_exonLines_from_exonerateGFF_CfloPep.rb #{base_model} fasta #{name} > #{name}.cds.fa"
    system cmd 
 else
    p base_model
    raise
  end

end
