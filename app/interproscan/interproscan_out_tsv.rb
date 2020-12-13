# -*- coding: utf-8 -*-
module InterProScan

  class TSVOut

# -*- coding: utf-8 -*-
# === Format definition ===
#
# https://interproscan-docs.readthedocs.io/en/latest/OutputFormats.html#tab-separated-values-format-tsv
#
# 1    Protein accession (e.g. P51587)
# 2    Sequence MD5 digest (e.g. 14086411a2cdf1c4cba63020e1622579)
# 3    Sequence length (e.g. 3418)
# 4    Analysis (e.g. Pfam / PRINTS / Gene3D)
# 5    Signature accession (e.g. PF09103 / G3DSA:2.40.50.140)
# 6    Signature description (e.g. BRCA2 repeat profile)
# 7    Start location
# 8    Stop location
# 9    Score - is the e-value (or score) of the match reported by member database method (e.g. 3.1E-52)
# 10   Status - is the status of the match (T: true)
# 11   Date - is the date of the run
# 12   InterPro annotations - accession (e.g. IPR002093)
# 13   InterPro annotations - description (e.g. BRCA2 repeat)
# 14   (GO annotations (e.g. GO:0005515) - optional column; only displayed if –goterms option is switched on)
# 15    (Pathways annotations (e.g. REACT_71) - optional column; only displayed if –pathways option is switched on)
#
# If a value is missing in a column, for example, the match has no InterPro annotation, a ‘-‘ is displayed.

    def self.summary(file, analyses)
      outfile = file
      data = []
      stats = {}

      File.open(outfile).each do |l|
        a = l.chomp.split(/\t/)
        data << a
      end

      stats['source'] = file
      stats['total_hits'] = data.size
      stats['num_queries_with_hits'] = data.map{|r| r[0]}.sort.uniq.size

      data_by_anal = {}
      stats_by_anal = {}
      analyses.each do |anal|
        data_by_anal[anal] = data.select{|r| r[3] == anal}
        stats_by_anal[anal] = {
          "num_hits" => data_by_anal[anal].size,
          "num_queries_with_hits" => data_by_anal[anal].map{|r| r[0]}.sort.uniq.size
        } 
      end

      stats['analyses'] = stats_by_anal

      return stats
    end

  end

end

if __FILE__ == $0
  analyses =  ["Pfam", "PANTHER", "SignalP_EUK", "SignalP_GRAM_NEGATIVE", "SignalP_GRAM_POSITIVE"]
  summary = InterProScan::TSVOut.summary(ARGV[0], analyses)
  require 'pp'
  require 'json'
  pp summary
#  puts summary.to_json
end





