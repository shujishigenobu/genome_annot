netf = ARGV[0]
sizef1 = ARGV[1] #query
sizef2 = ARGV[2] #target (ref)

MIN_LEN_ALIGN = 1000
FILL_ONLY = false
TOPLEVEL_FILLONLY = false

## TOPLEVEL_FILLONLY: If it is true, only top level 'fill' entries are reported and nested structure, 
##                    which is indented more deeply, is ignored.


#(input example)
#net GL349686 752019
# fill 2654 5894 ctg7180000032958 + 4586 5881 id 32383 score 486441 ali 5419 qDup 0 type top
#  gap 6615 150 ctg7180000032958 + 8550 150
# fill 8548 26200 ctg7180000042782 - 28168 21496 id 7652 score 1721366 ali 18995 qDup 0 type top
#  gap 10466 395 ctg7180000042782 - 47351 395
#

## Note: 0 start coordinate

size1 = {}
size2 = {}
File.open(sizef1).each do |l|
  a = l.chomp.split
  size1[a[0]] = a[1].to_i
end
File.open(sizef2).each do |l|
  a = l.chomp.split
  size2[a[0]] =a[1].to_i
end

chr = nil
File.open(netf).each do |l|
  if /^\#/.match(l)
    next
  elsif m = /^net/.match(l)
    a = l.split
    chr = a[1]
    
  elsif m = /^(\s+)fill/.match(l)
    type = "fill"
    level = m[1].size
    a = l.strip.split
    from_target = a[1].to_i
    size_target = a[2].to_i
    to_target = from_target + size_target
    name_query = a[3]
    score = /score (\d+)/.match(l)[1].to_i
    strand = a[4]
    from_query = a[5].to_i
    size_query = a[6].to_i
    to_query = from_query + size_query
    query_total_size = size1[name_query]
    target_total_size = size2[chr]
    name_target = chr

    if TOPLEVEL_FILLONLY && level > 1
      next
    end

    data = [name_query, name_target, score, type, level, strand,
            size_query,  query_total_size, sprintf("%.2f", size_query/query_total_size.to_f),
            from_query, to_query,    sprintf("%.2f", from_query/query_total_size.to_f),  sprintf("%.2f", to_query/query_total_size.to_f),
            size_target, target_total_size, sprintf("%.2f", size_target/target_total_size.to_f),
            from_target, to_target, sprintf("%.2f", from_target/target_total_size.to_f),  sprintf("%.2f", to_target/target_total_size.to_f),
           ]
    if size_target >= MIN_LEN_ALIGN
      puts  data.join("\t")
    end
#    puts bed.join("\t")
  elsif m = /^(\s+)gap/.match(l)
    type = "gap"
    level = m[1].size
    a = l.strip.split
    from_target = a[1].to_i
    size_target = a[2].to_i
    to_target = from_target + size_target
    name_query = a[3]
    score = 0
    strand = a[4]
    from_query = a[5].to_i
    size_query = a[6].to_i
    to_query = from_query + size_query
    

    data = [chr, from_target, to_target, name_query, score, strand, from_query, to_query, type, level,
            nil, nil]
    puts data.join("\t") unless (FILL_ONLY || TOPLEVEL_FILLONLY)
  else
  end

end
