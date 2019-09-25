fastaf = (ARGV[0] || "Trinity.fasta")
lineages_input = (ARGV[1] || "eukaryota") # (ex) "arthropoda,insecta"
                   # multiple databases can be given by separating "," 
                   # without spaces. Databases available are
#arthropoda
#bacteria
#eukaryota
#fungi
#insecta
#metazoa
#tetrapoda
#vertebrata

ncpus = (ARGV[2] || 8).to_i

templatef = "run_busco.template.sh"

templ = File.open(templatef).read

lineages = lineages_input.split(/,/)

valid_dbs = %w{
arthropoda
bacteria
eukaryota
fungi
insecta
metazoa
tetrapoda
vertebrata
}

lineages.each{|l| unless valid_dbs.include?(l) then raise "#{l}: invalid db" end}

txt = ""
lineages.each do |l|
  txt = templ.sub(/%FASTA%/, fastaf)
  txt = txt.sub(/%NCPU%/, ncpus.to_s)
  txt = txt.sub(/%LINEAGE%/, "#{l}_odb9")

  fname = "run_busco_#{l}.sh"
  
  File.open(fname, "w") do |io|
    io.puts txt
  end

end



#arthropoda_odb9
#bacteria_odb9
#eukaryota_odb9
#fungi_odb9
#insecta_odb9
#metazoa_odb9
#tetrapoda_odb9
#vertebrata_odb9

