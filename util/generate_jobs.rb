templatef = ARGV[0]
definition_file = ARGV[1]

template = File.open(templatef).read

n = 0
keywords = []
File.open(definition_file).each_with_index do |l, i|
  if i == 0 
    keywords = l.chomp.delete("#").split
    next
  end

  next if /^\#/.match(l)
  
  h = Hash.new
  script = template.dup

  a = l.chomp.split
  keywords.zip(a) do |k, v|
    h[k] = v
  end


  h.keys.each do |k|
    p [k, h[k]]
    script.gsub!(/%#{k}%/, h[k])
  end

  outf = File.basename(templatef, ".template.sh") + ".job#{n+=1}.sh"

  File.open(outf, "w") do |o|
    o.puts script
  end


end





