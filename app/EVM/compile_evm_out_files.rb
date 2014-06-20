Dir["scaffold_*/evm.out"].each do |path|
#  p path
  puts "## FILE: #{path}"
  puts File.open(path).read
  puts "//"
end
