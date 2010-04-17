class Api::WordsController < ApplicationController

  def create
    data = ActiveSupport::JSON.decode(request.body.string)
    begin
      Word.create!(data)
      render :text => "created", :status => 201
    rescue Exception => ex
      logger.error(ex.message)
      logger.error(ex.backtrace.join("\r\n"))
      render :text => "error", :status => 401
    end
  end

  def destroy
    stem = params["stem"]
    pos = params["pos"]
    begin
      if(stem && pos)
        w = Word.find(:first, :conditions => { :stem => stem, :pos => pos })
        if w
          w.destroy
          render :text => "destroyed", :status => 200
        else
          render :text => "not_found", :status => 404
        end
      else
        Word.destroy_all
        render :text => "destroyed", :status => 200
      end
    rescue Exception => ex
      logger.error(ex.message)
      logger.error(ex.backtrace.join("\r\n"))
      render :text => "error", :status => 401
    end
  end

end
