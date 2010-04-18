class Api::WordsController < ApplicationController

  def index
    begin
      if params[:relevant] && params[:relevant] == "true"
        if params[:max]
          ws = with_cache("words_relevant_max#{params[:max]}") do
            Word.find(:all, :conditions => { :relevant => true}, :order => "count DESC", :limit => params[:max])
          end
          render :json => ws.map(&:to_hash).to_json, :status => 200
        else
          ws = with_cache("words_relevant") do
            Word.find(:all, :conditions => { :relevant => true})
          end
          render :json => Word.find(:all, :conditions => { :relevant => true}).map(&:to_hash).to_json, :status => 200
        end
      else
        if params[:max]
          ws = with_cache("words_max#{params[:max]}") do
            Word.find(:all, :limit => params[:max], :order => "count DESC")
          end
          render :json => ws.map(&:to_hash).to_json, :status => 200
        else
          ws = with_cache("words") do
            Word.all
          end
          render :json => ws.map(&:to_hash).to_json, :status => 200
        end
      end
    rescue Exception => ex
      logger.error(ex.message)
      logger.error(ex.backtrace.join("\r\n"))
      render :text => "error #{ex.message}", :status => 401
    end
  end

  def create
    return render :text => "unauthorized", :status => 401

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
    return render :text => "unauthorized", :status => 401
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
