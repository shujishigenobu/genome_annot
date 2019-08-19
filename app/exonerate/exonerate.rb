module Exonerate

class CigarLine
  # Parser for Exonerate CIGAR line

  def self.match_pattern(query, target)
    raise unless query.size == target.size
    matches = []
    (0..(query.size-1)).each do |i|
      q = query[i]
      t = target[i]
      if q == t
        matches << 1
      elsif (q == "-" or t == "-")
        matches << "-" #gap
      else
        matches << 0 #"mismatch"
      end
    end
    matches.join
  end


  # create a CigarLine object
  # @param [String] line CIGAR line
  # @param [String] file path of query fasta (needs blastdb)
  # @param [String] file path of target fasta (needs blastdb)
  #
  def initialize(line, qfasta_file, tfasta_file)
    a = line.split
    @qid = a[0]
    @qstart = a[1].to_i
    @qend = a[2].to_i
    @qstrand = a[3]
    @tid = a[4]
    @tstart = a[5].to_i
    @tend = a[6].to_i
    @tstrand = a[7]
    @score = a[8]
    @cigar = a[9..-1].each_slice(2).to_a.map{|a, b| [a, b.to_i]}

    @qfasta_file = qfasta_file
    @tfasta_file = tfasta_file
  end

  attr_reader :qid, :qstart, :qend, :qstrand
  attr_reader :tid, :tstart, :tend, :tstrand
  attr_reader :score, :cigar

  def tseq
    unless @tseq
      @tseq = ""
      if @tstrand == "+"
        cmd = "blastdbcmd -db #{@tfasta_file} -entry #{@tid} -outfmt %s -range #{@tstart + 1}-#{@tend} -strand plus "
      elsif @tstrand == "-"
        cmd = "blastdbcmd -db #{@tfasta_file} -entry #{@tid} -outfmt %s -range #{@tend + 1}-#{@tstart} -strand minus "
      else
        raise
      end
#      puts cmd
      
      IO.popen(cmd){|io| @tseq = io.read}
    else
      @tseq
    end
  end

  def qseq
    unless @qseq
      @qseq = ""
 
      if @qstrand == "+"
        cmd = "blastdbcmd -db #{@qfasta_file} -entry #{@qid} -outfmt %s -range #{@qstart + 1}-#{@qend} -strand plus "
      elsif @qstrand == "-"
        cmd = "blastdbcmd -db #{@qfasta_file} -entry #{@qid} -outfmt %s -range #{@qend + 1}-#{qtstart} -strand minus "
      else
        raise
      end

      #      puts cmd
      
      IO.popen(cmd){|io| @qseq = io.read}
    else
      @qseq
    end
  end

  def alignment
    unless @aln
      q_at = 0
      t_at = 0
      q_aln = ""
      t_aln = ""
      cigar.each do |op, len|
        case op
        when "M"
          q_aln += qseq.slice(q_at, len)
          t_aln += tseq.slice(t_at, len)
          q_at += len
          t_at += len
        when "D"
          q_aln += "-" * len
          t_aln += tseq.slice(t_at, len)
          t_at += len
        when "I"
          t_aln += "-" * len
          q_aln += qseq.slice(q_at, len)
          q_at += len
        else
          raise "Unknown operation: #{op}"
        end
      end

      raise unless t_aln.size == q_aln.size

      @aln = {
        :target => t_aln, 
        :query => q_aln, 
        :match => CigarLine.match_pattern(t_aln, q_aln)
      }

    else
      @aln
    end

  end

  def alignment_query_based
    unless @aln_qbased
      t_aln = alignment[:target]
      q_aln = alignment[:query]
      q_aln_qbased = ""
      t_aln_qbased = ""
      (0..(q_aln.size-1)).each do |i|
        q = q_aln[i]
        t = t_aln[i]
        if q == "-"
        else
          q_aln_qbased << q
          t_aln_qbased << t
        end
      end

      @aln_qbased = {
        :query => q_aln_qbased,
        :target => t_aln_qbased,
        :match => CigarLine.match_pattern(q_aln_qbased, t_aln_qbased)
      }
    else
      @aln_qbased
    end

  end

  def alignment_target_based
  end

  def alignment_stats
    h = {
      :align_length => alignment[:match].size,
      :match        => alignment[:match].count("1"),
      :mismatch     => alignment[:match].count("0"),
      :indel        => alignment[:match].count("-")
    }
  end

  def alignment_query_based_stats
    aln = alignment_query_based
    h = {
      :align_length => aln[:match].size,
      :match        => aln[:match].count("1"),
      :mismatch     => aln[:match].count("0"),
      :indel        => aln[:match].count("-")
    }
    identity = h[:match].to_f / (h[:match] + h[:mismatch])
    h.update({:identity => identity})
    h
  end

end #class

end #module

if __FILE__ == $0
  line = "XM_001727036.1 0 1614 + 000001F 4798409 4800176 + 8002  M 216 D 48 M 479 D 55 M 338 D 50 M 581"
  line = "XM_001727040.1 0 1512 + 000001F 4783841 4785406 + 7336  M 483 D 53 M 1029"
  line = "XM_001727893.3 0 1689 + 000001F 2120509 2122409 + 8305  M 358 D 110 M 7 I 2 M 32 D 50 M 151 D 53 M 1139"
  line = "XM_001727044.3 0 585 + 000001F 4778170 4777387 - 2880  M 183 D 126 M 97 D 72 M 305"

  include Exonerate

  cl = CigarLine.new(line, "GCF_000184455.2_ASM18445v3_rna.fna", "AspOr_A06_genome_v1.fasta")

  aln =  cl.alignment
  puts aln[:query]
  puts aln[:target]
  puts aln[:match]

  aln_qb = cl.alignment_query_based
  puts aln_qb[:query]
  puts aln_qb[:target]
  puts aln_qb[:match]

  p cl.alignment_stats
  p cl.alignment_query_based_stats

  exit

end
