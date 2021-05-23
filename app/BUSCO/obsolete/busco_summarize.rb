busco_out_dirs = ARGV

busco_keys = %w{C S D F M}

busco_out_dirs.each do |dir|
  short_summary_file = Dir["#{dir}/short_summary_*.txt"][0]
  txt = File.open(short_summary_file).read
  db = /^\# The lineage dataset is: (.+?)\s/.match(txt)[1]
  oneline = /^\s+(C:.+)/.match(txt)[1]

  busco_count = []
  txt.split(/\n/)[-6..-1].each do |l|
    a = l.chomp.split(/\t/)
    busco_count << a[1].to_i
  end

  puts [db, oneline, busco_count.join(",")].join("\t")
  

end
