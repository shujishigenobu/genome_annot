module EggNogMapper
  class OutputV2

# === Format ===

#1. query_name
#2. seed eggNOG ortholog
#3. seed ortholog evalue
#4. seed ortholog score
#5. Predicted taxonomic group
#6. Predicted protein name
#7. Gene Ontology terms 
#8. EC number
#9. KEGG_ko
#10. KEGG_Pathway
#11. KEGG_Module
#12. KEGG_Reaction
#13. KEGG_rclass
#14. BRITE
#15. KEGG_TC
#16. CAZy 
#17. BiGG Reaction
#18. tax_scope: eggNOG taxonomic level used for annotation
#19. eggNOG OGs 
#20. bestOG (deprecated, use smallest from eggnog OGs)
#21. COG Functional Category
#22. eggNOG free text description

COLNAMES = [
            :query,     # 1. query_name
            :seed_orth, # 2. seed eggNOG ortholog
            :seed_orth_evalue, # 3. seed ortholog evalue
            :seed_orth_score,  # 4. seed ortholog score
            :taxon,     # 5. Predicted taxonomic group
            :protein_name,   # 6. Predicted protein name
            :go_terms,   # 7. Gene Ontology terms 
            :ec_numbers, # 8. EC number
            :kegg_ko,   # 9. KEGG_ko
            :kegg_pathways,   # 10. KEGG_Pathway
            :kegg_modules,  # 11. KEGG_Module
            :kegg_reactions, # 12. KEGG_Reaction
            :kegg_rclasses, # 13. KEGG_rclass
            :brite,     # 14. BRITE
            :kegg_tc,    # 15. KEGG_TC
            :cazy,      # 16. CAZy 
            :bigg_react, #17. BiGG Reaction
            :tax_scope, # 18. tax_scope: eggNOG taxonomic level used for annotation
            :eggnog_ogs, # 19. eggNOG OGs 
            :best_og,    # 20. bestOG (deprecated, use smallest from eggnog OGs)
            :cog,        # 21. COG Functional Category
            :desc,       #22. eggNOG free text description
           ]
    def self.parse_line(line)
      if /^\#/.match(line)
        return nil
      else
        a = line.chomp.split(/\t/, -1)
        h = {}
        a.zip(COLNAMES).each do |val, key|
          h[key] = val
        end
        ## process mulitiple values
        [:go_terms, :eggnog_ogs, :brite, :kegg_pathways, :kegg_rclasses, :kegg_reactions, :kegg_modules].each do |k|
          h[k] = h[k].split(/,/)
        end
        return h
      end
    end

    def self.summarize(file)
      data = []
      File.open(file).each do |l|
        h = parse_line(l)
        data << h if h
      end
      stats = {}
      stats['num_queries_annotated'] = data.size
      stats['num_queries_go_assined'] = data.select{|d| d[:go_terms].size > 0}.size
      stats['num_queries_eggnog_og_assined'] = data.select{|d| d[:eggnog_ogs].size > 0}.size
      return stats
    end

  end
end

if __FILE__ == $0
  require 'pp'
 # File.open(ARGV[0]).each do |l|
 #   h = EggNogMapper::OutputV2.parse_line(l)
 #   pp h
 # end

p  EggNogMapper::OutputV2.summarize(ARGV[0])
end
