#!/bin/env ruby

#===
# contigs_basic_stats.rb 
#
# Reading an assembling result as muti-FASTA and get some basic statistcs 
# such as N50
#
# Shuji Shigenob <shige@nibb.ac.jp>

require 'rubygems'
require 'optparse'
require 'bio'

include Bio

SIZE_BREAKS = [100, 500, 1000, 5000, 10000, 50000, 100000, 500000, 1000000]
DEFAULT_NUM_SHOW_LONGEST = 20

def show_help
  puts "Usage:
   contigs_basic_stats.rb  FASTA"
end

if ARGV[0] == "-h" || ARGV[0] == "--help" || ARGV[0].nil?
  show_help
  exit
end

assm_file = ARGV[0]
num_longest = (ARGV[1] || DEFAULT_NUM_SHOW_LONGEST).to_i

def num_delimit(int)
  # input should be integer
  if int.is_a?(Integer)
    out = int.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse
  else
    STDERR.puts int.inspect
    raise "object should be a Integer."
  end
  out
end

fastas = []
data = {}

FlatFile.open(FastaFormat, assm_file).each do |fa|
  fastas << fa
end

fastas.sort!{|a, b| b.seq.length <=> a.seq.length}
total_bases = fastas.map{|fa| fa.seq.length}.inject(0){|i, j| j += i}

lens_sorted = fastas.map{|f| f.seq.length}

data['num_contigs'] = lens_sorted.size
data['longest'] = lens_sorted[0]
data['shortest'] = lens_sorted[-1]
data['total_bases'] = total_bases

base_count = Hash.new(0)
fastas.each do |fas|
  seq = fas.seq.upcase
  %w{A T G C N}.each do |b|
    base_count[b] += seq.count(b)
  end
end

data['gc_perc'] = (base_count["G"] + base_count["C"]).to_f / (base_count["A"] + base_count["T"] + base_count["G"] + base_count["C"]) * 100

data['total_bases_atgc'] = base_count["A"] + base_count["T"] + base_count["G"] + base_count["C"]
data['total_bases_Ns'] = base_count["N"]

sum = lens_sorted.inject(0){|i, j| j += i}
mean = sprintf("%.1f", sum.to_f / lens_sorted.size )
data['mean'] = mean

data['median'] = lens_sorted[lens_sorted.size / 2]

cum = 0
n50, n60, n70, n80, n90 = nil

fastas.each_with_index do |fa, i|
  cum += fa.seq.length
  if n50 == nil &&  cum / total_bases.to_f > 0.5
    n50 = fa.seq.length
  elsif n60 == nil && cum / total_bases.to_f > 0.6
    n60 = fa.seq.length
  elsif n70 == nil && cum / total_bases.to_f > 0.7
    n70 = fa.seq.length
  elsif n80 == nil && cum / total_bases.to_f > 0.8
    n80 = fa.seq.length
  elsif n90 == nil && cum / total_bases.to_f > 0.9
    n90 = fa.seq.length
  end
#    puts [i+1, fa.entry_id, fa.seq.length, cum+=fa.seq.length, cum / total_bases.to_f].join("\t")
end


data['N50'] = n50
data['N60'] = n60
data['N70'] = n70
data['N80'] = n80
data['N90'] = n90

puts "#=== Assembly Basic Statistics === "
puts "#"
puts "# seq_file: #{ARGV[0]}"
puts "# script:   #{__FILE__}"
puts "# user:     #{ENV['USER']} @ #{ENV['HOSTNAME']}"
puts "# date:     #{Time.now}"
puts "#"
puts "### Basic Statistics"
%w{num_contigs shortest longest mean median N50 N60 N70 N80 N90 total_bases total_bases_atgc total_bases_Ns }.each do |k|
  if data[k].is_a?(Integer)
    puts [k, num_delimit(data[k])].join("\t")
  else
    puts [k, data[k]].join("\t")
  end
end
puts "#"
puts "### Nucleotide Counts"
puts "# " + %w{A T G C}.map{|b| "#{b}: #{base_count[b]} (" + 
  sprintf("%.1f%%", (base_count[b]/total_bases.to_f * 100.0)) + ")" }.join(", ")
puts "# Others: #{nothers = data['total_bases'] - data['total_bases_atgc']} (" + sprintf("%.1f%%", (nothers / total_bases.to_f * 100.0)) + ")" 
puts "# %GC\t" + sprintf("%.1f", data['gc_perc'])
puts "#"
puts "### Size Distribution "

SIZE_BREAKS.reverse.each do |br|
  cnt = lens_sorted.select{|l| l >= br}.size
  puts [">= #{br}", num_delimit(cnt)].join("\t")
end

puts "#"
puts "### Longest contigs"
fastas.each_with_index do |f, i|
  puts [i+1, f.entry_id, num_delimit(f.seq.size)].join("\t")
  break if i>= (num_longest - 1)
end
