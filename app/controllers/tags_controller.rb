class TagsController < ApplicationController

  def show
    begin
      stem = params[:stem]
      pos = params[:pos]
      freqs = Session.all.sort{ |a,b| a.date <=> b.date }.collect do |s|
        sw = s.session_words.detect{ |w| w.stem == stem && w.pos == pos }
        if sw
          [s.date, sw.count]
        else
          [s.date, 0]
        end
      end

      @freqs_values = []
      @freqs_legend = []
      freqs.each_with_index do |v,i|
        @freqs_legend << [i,v[0]]
        @freqs_values << [i,v[1]]
      end

      @intervention_word = InterventionWord.find(:first, :conditions => ["stem=? and pos=?", stem, pos])
      @sessions = SessionWord.find(:all, :conditions => ["stem=? and pos=?", stem, pos]).collect{ |sw| sw.session }
      @error = false
    rescue Exception => ex
      logger.error("error message: #{ex.message}")
      logger.error(ex.backtrace)
      @error = true
    end
  end

end
