require 'json'

class BuscoResult

  def initialize(txt)
    @data = parse_short_summary_txt(txt)
  end

  def data
    @data
  end

  def to_json
    data.to_json
  end

  def one_line_summary
    str = [data['lineage'], 
    data['one_line_summary'],
    ["C","S","D","F","M","total"].map{|k| data[k]}.join(",")].join("\t")
    str
  end

  def parse_short_summary_txt(txt)
    h = {}
    nline_in_result = nil
    summary_line = nil
    txt.split(/\n/).each do |l|
      if m = /^\# The lineage dataset is: (.+?)\s/.match(l)
        h['lineage'] = m[1]
      end
      if /\s+\*+ Results:/.match(l)
        nline_in_result = 0
      end
      if nline_in_result
        if m = /\s+(C:.+)/.match(l)
          summary_line = m[1].strip
          nline_in_result += 1
          h['one_line_summary'] = summary_line
        elsif m = /\s+(\d+)\s+.+\(([CSDFM])\)/.match(l)
          count = m[1].to_i
          category = m[2]
  #          p [category, count]
          h[category] = count
        elsif m = /\s+(\d+)\s+Total BUSCO/.match(l)
          total_count = m[1].to_i
          h['total'] = total_count
        end
      end
    end
    return h
  end
end

if __FILE__ == $0

  txt = File.open(ARGV[0]).read
  b = BuscoResult.new(txt)
  #puts b.to_json
  puts b.one_line_summary

end