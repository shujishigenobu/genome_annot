listf = ARGV[0]
num = ARGV[1].to_i

commands = File.open(listf).readlines

k = 0
out = nil
commands.shuffle.each_with_index do |c, i|
  if i % num == 0
    jobf = File.basename(listf) + "_#{k += 1}"
    out =File.open(jobf, "w")
  else
  end
  out.puts c 

end
