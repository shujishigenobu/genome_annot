source = ARGV[0]
ori = ARGV[1] # fwd or rev

if ori == "fwd"
  postfix = "F"
elsif ori == "rev"
  postfix = "R"
else
  raise
end

def name_change(name, postfix)
  if m = /\.\d+$/.match(name)
    newid = m.pre_match + postfix + m[0]
  elsif m = /\.\d+\.exon\d+$/.match(name)
    newid = m.pre_match + postfix + m[0]
  else
    raise
  end 
  newid
end

File.open(source).each do |l|
  if l == "\n"
    puts l
  else
    new_attributes = []
    l.chomp.split(/\t/)[8].split(/;/).each do |attribute|
      key, value = attribute.split(/\=/)
      newvalue = name_change(value, postfix)
      new_attributes << "#{key}=#{newvalue}"
    end
    a = l.chomp.split(/\t/)
    b = a.dup
    b[8] = new_attributes.join(";")
    line = b.join("\t")
    line = line.gsub(/%20/, ":")
    puts line
  end
end
