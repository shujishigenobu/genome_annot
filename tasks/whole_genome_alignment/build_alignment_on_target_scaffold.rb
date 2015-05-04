class MafPairwiseAlignment

  def initialize(file)
    @file = file
    read_maf_file
  end

  attr_reader :file, :name1, :name2, :seq1, :seq2

  def read_maf_file
    name1, name2 = nil, nil
    seq1, seq2 = "", ""
    File.open(@file).each do |l|
      if (m = /^>/.match(l)) && name1 == nil
        name1 = m.post_match.split[0]
      elsif (m = /^>/.match(l)) && name2 == nil
        name2 = m.post_match.split[0]
      elsif name1 && name2 == nil
        seq1 << l.chomp
      elsif name2
        seq2 << l.chomp
      else
        raise
      end
    end
    
    @name1 = name1
    @name2 = name2
    @seq1 = seq1
    @seq2 = seq2
  

    name1orig = name1
    name2orig = name2

    @name1 = @name1.sub(/^lcl\|/, '')
    @name2 = @name2.sub(/^lcl\|/, '')

    m1 = /^(.+):(\d+)\-(\d+)$/.match(name1)
    name1 = m1[1]
    name1_from = m1[2].to_i
    name1_to = m1[3].to_i

    m2 = /^(.+):c*(\d+)\-(\d+)$/.match(name2)
    name2 = m2[1]
    name2_from = m1[2].to_i
    name2_to = m1[3].to_i
    name2_compl = true if /^.+:c\d+\-\d+$/.match(name2orig)
    
  end

  def seq2_imposed_on_seq1
    if @seq2_imposed_on_seq1
      @seq2_imposed_on_seq1
    else
      seq1a = seq1.split(//)
      seq2a = seq2.split(//)
      seq1new = []
      seq2new = []
      seq1a.each_with_index do |s, i|
        seq1s = seq1a[i]
        seq2s = seq2a[i]
        
        if seq2s == "-"
          seq1new << seq1s
          seq2new << seq2s
        elsif seq1s == "-"
          # do nothing
        else
          seq1new << seq1s
          seq2new << seq2s
        end
      end # do
      @seq2_imposed_on_seq1 = seq2new.join
    end # if else
  end # def

  def seq1_unaligned
    if @seq1_unaligned
      @seq1_unaligned
    else
      @seq1_unaligned = seq1.delete("-")
    end
  end

end

#file = ARGV[0]
#pa = MafPairwiseAlignment.new(file)
#p pa.seq2_imposed_on_seq1
#p pa.seq1.size
#p pa.seq2_imposed_on_seq1.size
#p pa.seq1_unaligned.size
#p pa


conffile = ARGV[0]
conftxt = ""
synteny_info = []
File.open(conffile).each do |l|
  break if /\#\#\s*end conf/.match(l)
  conftxt << l
end
File.open(conffile).each do |l|
  a = l.chomp.split(/\t/)
  next unless a.size > 3
  next if /^\#/.match(l)
  h = {:tName => a[0], :tStart => a[1].to_i, :tEnd => a[2].to_i, :jobName => a[-1]}
  synteny_info << h
end

#puts conftxt
require 'yaml'
conf = YAML.load(conftxt)
#p synteny_info

#====
# build alignment 
##scaffold_42   length=4092633
#scaffold_42     1803858 1804593 735     21786   scaffold468     1021874 1022678 804     +       0       2897
#scaffold_42     1807790 1878959 71169   792673  scaffold864     267509  325401  57892   -       0       2898
#scaffold_42     1882872 2159103 276231  3468314 scaffold864     326040  553228  227188  -       0       2899
#p conf
qalign_on_seq1 = "-" * conf['length']

synteny_info.each do |s|
  tstart = s[:tStart]
  tend = s[:tEnd]
  tsize = tend - tstart

  mfa_file = "#{conf['mfa_dir']}/#{s[:jobName]}.lagan.out.mfa"

  unless File.exist?(mfa_file)
    STDERR.puts "ERROR: #{mfa_file} not found in processing #{conf['scaffold']}"
    next
  end

  pa = MafPairwiseAlignment.new(mfa_file)  
#  puts pa.seq1_unaligned.size
#  puts pa.seq2_imposed_on_seq1.size
#p pa

#  raise unless seq2new.size == tsize
  qalign_on_seq1[tstart, tsize] = pa.seq2_imposed_on_seq1
end

cmd = "blastdbcmd -db #{conf['scaffold_fasta']} -entry #{conf['scaffold']} "
res = nil
IO.popen(cmd){|io| res = io.read}

File.open(conf['outfile'], "w") do |o|
  o.puts res.sub(/^>lcl\|/, ">")
  o.puts ">#{conf['aligned_query_name']}"
  o.puts qalign_on_seq1.gsub(/(.{,60})/, "\\1\n")
end
