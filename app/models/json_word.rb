module JsonWord
  module ToInclude

    def check_valid
      w = Word.find(:first, :conditions => ["stem=? and pos=?", stem, pos])
      if w
        self.relevant = w.relevant
      else
        if count > 10
          self.relevant = true
        else
          self.relevant = false
        end
      end

      self.save!
    end

    def pos_string
      if pos == "NC"
        "Sustantivo"
      elsif pos == "Adj"
        "Adjetivo"
      else
        "Verbo"
      end
    end

    def to_hash
      h = {
        :stem => stem,
        :pos => pos,
        :literal => literal,
        :lemma => lemma,
        :count => count
      }
      if date
        h[:date] = date
      end
      h
    end
  end
  module ToExtend
    def parse_date(data)
      if data["date"]
        y, m, d =data["date"].split(".")
        data["date"] = Date.new(y.to_i,m.to_i,d.to_i)
      end
      data
    end

    def parse_words(to_merge,words)
      words.each do |w|
        w = parse_date(w)
        self.new(w.merge(to_merge)).save!
      end
    end
  end
end
