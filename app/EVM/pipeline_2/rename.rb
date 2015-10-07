source = ARGV[0]
ori = (ARGV[1] || "fwd")

if ori == "fwd"
  postfix = "F"
elsif ori == "rev"
  postfix = "R"
else
  raise
end

File.open(source).each do |l|
  line = l.gsub(/(scaffold_\d+)\./, "\\1.#{postfix}")
  line = line.gsub(/%20/, ":")
  puts line
end
