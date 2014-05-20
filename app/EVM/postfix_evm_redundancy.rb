require 'pp'

blocks = []
blocks << []
ARGF.each do |l|
  unless l == "\n"
    blocks.last << l.chomp
  else
    blocks << []
  end
end

blocks.delete([]) # delete empty blocks

STDERR.puts blocks.size

models = {}
blocks.each do |bl|
  name = /ID\=(.+?);/.match(bl[0])[1]
  models[name] = {}
  models[name][:lines] = []
  bl.each do |l|
    models[name][:lines] << l
  end
  models[name][:structure1] = []
  bl.each do |l|
    a = l.chomp.split
    models[name][:structure1] << [a[0], a[2], a[3].to_i, a[4].to_i, a[6]]
  end
  
end

models.keys.each do |x|
  found_identical = []
  models.keys.each do |y|
    next if y == x
    if (models[x][:structure1] == models[y][:structure1])
      found_identical << y
    end
  end
#  p [x, found_identical]
end

#pp models.to_a

models_uniq = models.to_a.uniq{|m| m.last[:structure1]}

STDERR.puts models_uniq.size

models_uniq.each do |k, v|
  puts v[:lines]
  puts ""
end
