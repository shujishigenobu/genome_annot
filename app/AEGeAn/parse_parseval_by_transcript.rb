in_locus_data = false
seqid, range = nil
next_is_ref = false
next_is_pred = false
ref_gene, pred_gene = nil
in_comparison = false
comparison = nil
in_cds_comp = true

data = []

File.open(ARGV[0]).each do |l|
#  p next_is_ref
  if m = /^\s+\|---- Begin comparison ----/.match(l)
#    seqid, range = nil

    in_comparison = true
    next_is_ref = false
    next_is_pred = false


    data << {
      :ref_transcripts => nil,
      :pred_transcripts => nil,
    }

  elsif m = /^\s+\|  reference transcripts:/.match(l)
    data.last[:ref_transcripts] = []
    next_is_ref = true
  elsif next_is_ref == true

    if /^\s+\|\n/.match(l)

      next_is_ref = false
      next
    elsif m = /^\s+\|  prediction transcripts:/.match(l)

      next_is_ref = false
      next_is_pred = true
      data.last[:pred_transcripts] = []
      next
    else

      data.last[:ref_transcripts] << /^\s+\|\s+(\S+)/.match(l)[1]
    end
  elsif m = /^\s+\|  prediction trancripts:/.match(l)

    next_is_pred = true
  elsif next_is_pred == true
    if /^\s+\|\n/.match(l)
      next_is_pred = false
      next
    else
      data.last[:pred_transcripts] << /^\s+\|\s+(\S+)/.match(l)[1]
    end
  elsif /\s+\|\s+Gene structures match perfectly/.match(l)
    data.last[:comparison] = "PerfectMatch"
  elsif /\s+\|\s+CDS structure comparison/.match(l)
    in_cds_comp = true
  elsif m = /\s+\|\s+Annotation edit distance:/.match(l)
    if in_cds_comp == true
      data.last[:comparison] = m.post_match.chomp.strip
      in_cds_comp = false
    end
  elsif /\s+\|----- End comparison -----/.match(l)
    in_comparison = false
#    p data.last
  else
    
  end
end

## output
puts "# source: #{ARGV[0]}"
puts "# date:   #{Time.now}"
puts "#"
puts "# " + %w{seqid range ref_gene pred_gene}.join("\t")
data.each do |d|
  outdata = [
             d[:ref_transcripts].join(","), 
             d[:pred_transcripts].join(","),
             d[:comparison]
            ]
  puts outdata.join("\t")
end
