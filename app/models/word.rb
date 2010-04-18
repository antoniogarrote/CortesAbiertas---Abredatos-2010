class Word < ActiveRecord::Base
    def to_hash
      h = {
        :stem => stem,
        :pos => pos,
        :literal => literal,
        :lemma => lemma,
        :count => count,
        :relevant => relevant || false
      }
      if date
        h[:date] = date
      end
      h
    end
end
