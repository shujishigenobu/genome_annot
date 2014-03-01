inputf = ARGV[0]
source = ARGV[1]

File.open(ARGV[0]).each do |l|
  a = l.chomp.split(/\t/)
  if a[2] == "match_part"
    id = /^Parent\=(.+)?/.match(a[8])[1]
    if source
      a[1] = source
    end
    puts [a[0..7], "ID=#{id};Target=#{id}"].flatten.join("\t")
  end
end
