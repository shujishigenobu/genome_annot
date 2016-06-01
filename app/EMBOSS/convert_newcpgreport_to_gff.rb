#
#
## format example
=begin
ID   scaffold_0  14294479 BP.
XX
DE   CpG Island report.
XX
CC   Obs/Exp ratio > 0.60.
CC   % C + % G > 50.00.
CC   Length > 200.
XX
FH   Key              Location/Qualifiers
FT   CpG island       125378..125633
FT                    /size=256
FT                    /Sum C+G=133
FT                    /Percent CG=51.95
FT                    /ObsExp=1.18
FT   CpG island       126962..127466
FT                    /size=505
FT                    /Sum C+G=261
FT                    /Percent CG=51.68
FT                    /ObsExp=1.01
=end

seqid = nil
cgi = nil
cgis = []
File.open(ARGV[0]).each do |l|
#  p l
  next if (/^XX/.match(l) || %r{^//}.match(l))
  
  m = /^([A-Z]{2})\s+/.match(l.chomp)
  tag = m[1]
  rec = m.post_match
#  p [tag, rec]
  if tag == "ID"
    seqid = rec.split[0]
  elsif tag == "FT"
    if m2 = /^CpG island\s+(\d+)\.\.(\d+)/.match(rec)
#      p cgis.last if cgis.last
      cgi = Hash.new
      cgis << cgi
      cgis.last[:seqid] = seqid
      cgis.last[:from] = m2[1].to_i
      cgis.last[:to] = m2[2].to_i

    elsif m2 = /numislands\s+(\d+)/.match(rec)
      # do nothing
    elsif /no islands detected/.match(rec)
      # do nothing
    else
      m2 = %r{^\/(.+)\=(.+)}.match(rec)
     key = m2[1]
      val = m2[2]
#      p [key, val]
      cgis.last[key] = val
   end
  end

end

cgis.each_with_index do |c, i|
  ary = [c[:seqid], 
         "newspgreport",
         "CpG_island",
         c[:from],
         c[:to],
         c["ObsExp"],
         ".",
         ".",
         "ID=CGI#{i+1};size=#{c['size']};SumCG=#{c['Sum C+G']};PercentCG=#{c['Percent CG']};ObsExp=#{c['ObsExp']}"]
  puts ary.join("\t")
end
