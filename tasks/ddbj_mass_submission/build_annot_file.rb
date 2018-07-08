fastaf = ARGV[0]
tmpl_common = ARGV[1]
tmpl_entry = ARGV[2]
gap_bed = ARGV[3]

## check contig length
id2len = {}
require 'bio'
Bio::FlatFile.open(Bio::FastaFormat, fastaf).each do |fas|
  id2len[fas.entry_id] = fas.length
end

## Load common annot
ann_common = ""
File.open(tmpl_common).each do |l|
  ann_common << l unless /^\#/.match(l)
end

## Load entry templ
ann_entry_template = ""
File.open(tmpl_entry).each do |l|
  ann_entry_template << l unless /^\#/.match(l)
end

## load gap info
gap_bed_by_chr = {}
File.open(gap_bed).each do |l|
  a = l.chomp.split(/\t/)
  unless gap_bed_by_chr.has_key?(a[0])
    gap_bed_by_chr[a[0]] = []
  end
  gap_bed_by_chr[a[0]] << a
end


## build annotation text

ann_common.delete!('"')
puts ann_common

id2len.keys.each do |id|
  txt = ann_entry_template.sub(/%ENTRY%/, id)
  txt.sub!(/%RANGE%/, "1..#{id2len[id]}")
  puts txt

  gaps = gap_bed_by_chr[id]
  gaps.each do |g|
    puts [nil, "assembly_gap", "#{g[1].to_i + 1}..#{g[2].to_i}", "estimated_length", "known"].join("\t")
    puts [nil, nil, nil, "gap_type", "within scaffold"].join("\t")
    puts [nil, nil, nil, "linkage_evidence", "paired-ends"].join("\t")
  end
end




