TOPLEVEL_FILL_ONLY = false
MIN_LEN_ALIGN = 1

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


if TOPLEVEL_FILL_ONLY
  r = /^ fill/
else
  r = /^\s+fill/
end

chr = nil
ARGF.each do |l|
  if /^\#/.match(l)
    next
  elsif m = /^net/.match(l)
    chr = l.split[1]
  elsif m = r.match(l)
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

    data = [chr, from_target, to_target, name_query, score, strand, from_query, to_query]

    if size_target >= MIN_LEN_ALIGN
      puts  data.join("\t")
    end
#    puts bed.join("\t")
  else
  end

end
