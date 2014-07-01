

class IdConverter

  def initialize(table)
    @table_file = table
    ## assuming 1-to-1 relationship
    @old2new = {}
    @new2old = {}
    File.open(@table_file).each do |l|
      a = l.chomp.split(/\t/)
      new = a[0]
      old = a[1]
      old2new[old] = new
      new2old[new] = old
    end
  end

  attr_reader :old2new, :new2old

  def process_tab_text(file, nthcol)
    ## nthcol: target column (Nth column)
    File.open(file).each do |l|
      if /^\#/.match(l)
        puts l
        next
      end
      a = l.chomp.split(/\t/)
      oldid = a[nthcol]
      newid = old2new[oldid]
      b = a.dup
      b[nthcol] = new
      puts b.join("\t")
    end
  end

  def process_fasta(file)
    File.open(file).each do |l|
      if m = /^>(\S+)\s/.match(l)
        oldid = m[1]
        newid = old2new[oldid]
        newdefline = l.sub(/#{Regexp.escape(oldid)}/, newid)
        puts "#{newdefline}"
      else
        puts l
      end
    end
  end

end

if __FILE__ == $0

  input = ARGV[0]
  convert_table = "new_old_id_table.txt"

  ic = IdConverter.new(convert_table)
#  ic.process_tab_text(input, 0)
  ic.process_fasta(input)
end

