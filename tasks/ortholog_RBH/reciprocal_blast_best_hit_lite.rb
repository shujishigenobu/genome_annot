blast1 = ARGV[0]
blast2 = ARGV[1]

def read_blast_table(blast_file)
	h = Hash.new
	prev_id = ""
	File.open(blast_file).each do |l|
		a = l.chomp.split(/\t/)
		id = a[0]
		hitid = a[1]
		if prev_id != id

			h[id] = []
			h[id] << a
		elsif h[id].first[1] == hitid
			h[id] << a
		else

		end
		prev_id = id
	end
	return h
end

h1 = read_blast_table(blast1)
h2 = read_blast_table(blast2)

h1.keys.sort.each do |k|
	id1 = k
	besthit1 = h1[k].first[1]
#	p [id1, besthit1]
	besthit2 = h2.fetch(besthit1, [[]]).first[1]
#	p [besthit1, besthit2]
	if id1 ==  besthit2
		## reciprocal best hit :yes
		puts h1[k].first.join("\t")
	end

end
