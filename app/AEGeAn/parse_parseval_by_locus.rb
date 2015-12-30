in_locus_data = false
seqid, range = nil
next_is_ref = false
next_is_pred = false
ref_gene, pred_gene = nil

data = []

ARGF.each do |l|
#  p next_is_ref
  if m = /\|---- Locus:/.match(l)
    seqid, range = nil
    next_is_ref = false
    next_is_pred = false
    ref_gene, pred_gene = nil


    data << {:seqid => nil, 
      :range => nil,
      :ref_gene => nil,
      :pred_gene => nil,
    }


    ## (ex) seqid=scaffold_321 range=73416-81010\n
    s = m.post_match.strip
    m2 = /seqid\=(.+)\s+range\=(.+)$/.match(s)
    data.last[:seqid] = m2[1]
    data.last[:range] = m2[2]
  elsif m = /^\|  reference genes:/.match(l)
    data.last[:ref_gene] = []
    next_is_ref = true
  elsif next_is_ref == true
    if /^\|\n/.match(l)
      next_is_ref = false
      next
    else
      data.last[:ref_gene] << /^\|\s+(\S+)/.match(l)[1]
    end
  elsif m = /^\|  prediction genes:/.match(l)
    data.last[:pred_gene] = []
    next_is_pred = true
  elsif next_is_pred == true
    if /^\|\n/.match(l)
      next_is_pred = false
      next
    else
      data.last[:pred_gene] << /^\|\s+(\S+)/.match(l)[1]
    end
  else

  end
end

data.each do |d|
  outdata = [d[:seqid], d[:range], d[:ref_gene].join(","), d[:pred_gene].join(",")]
  puts outdata.join("\t")
end
