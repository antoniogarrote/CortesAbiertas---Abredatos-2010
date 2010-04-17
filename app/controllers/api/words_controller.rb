class Api::WordsController < ApplicationController

  def create
    data = ActiveSupport::JSON.decode(request.body.read)

    y, m, d =data["date"].split(".")
    data["date"] = Date.new(y.to_i,m.to_i,d.to_i)

    begin
      found = Word.find(:first, :conditions => { "stem" => data["stem"],
                                                 "pos"  => data["pos"] })
      if found
        found.count += data["count"]
        found.save!
      else
        Word.create!(data)
      end
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
