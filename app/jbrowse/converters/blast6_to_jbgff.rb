source = "megablast"

BLAST_TABLE_KEYS = %w{ qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore }

prev = nil
block = []
counter = 0

io = File.open(ARGV[0])

io.each_with_index do |l, i|
  h = Hash.new
  a = l.chomp.split(/\t/, -1)
  BLAST_TABLE_KEYS.zip(a){|k, v| h[k] = v}

  if io.eof? || (prev && !(h['qseqid'] == prev['qseqid'] && h['sseqid'] == prev['sseqid']) )
    counter += 1
    id = "#{block[0]['qseqid']}_#{counter}"
    x = block.map{|k| [k['sstart'].to_i, k['send'].to_i]}.flatten.sort
    from = x.min
    to = x.max

    strand = (block[0]['sstart'].to_i < block[0]['send'].to_i ? "+" : "-")
    gffline = [block[0]['sseqid'],
               source,
               "match",
               from,
               to,
               block[0]['bitscore'],
               strand,
               ".",
               "ID=#{id}"]
    puts gffline.join("\t")
    
    block.each do |k|
      gffline2 = [k['sseqid'],
                  source,
                  "match_part",
                  [k['sstart'].to_i, k['send'].to_i].sort,
                  k['bitscore'],
                  (block[0]['sstart'].to_i < block[0]['send'].to_i ? "+" : "-"),
                  ".",
                  "Parent=#{id}"]
      puts gffline2.join("\t")
    end
    
 #   puts block
#    puts "//"
    block = []
    block << h
  else
    block << h
  end
    prev = h.dup
end

io.close
