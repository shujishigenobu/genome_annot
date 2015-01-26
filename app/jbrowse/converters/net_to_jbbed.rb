#(input example)
#net GL349686 752019
# fill 2654 5894 ctg7180000032958 + 4586 5881 id 32383 score 486441 ali 5419 qDup 0 type top
#  gap 6615 150 ctg7180000032958 + 8550 150
# fill 8548 26200 ctg7180000042782 - 28168 21496 id 7652 score 1721366 ali 18995 qDup 0 type top
#  gap 10466 395 ctg7180000042782 - 47351 395
#

## Note: 0 start coordinate

## ToDo: Current script process only top level 'fill' entries. Nested structure, which is indented more deeply, is ignored. 
#        This should be improved in the future.

chr = nil
ARGF.each do |l|
  if /^\#/.match(l)
    next
  elsif m = /^net/.match(l)
    chr = l.split[1]
  elsif m = /^ fill/.match(l)
    a = l.strip.split
    from = a[1].to_i
    size = a[2].to_i
    to = from + size
    name = a[3]
    score = /score (\d+)/.match(l)[1].to_i
    strand = a[4]

    bed = [chr, from, to, name, score, strand]
    puts bed.join("\t")
  else
  end

end
