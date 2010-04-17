class Api::SessionsController < ApplicationController

  def create
    b = request.body.read
    data = ActiveSupport::JSON.decode(b)
    begin
      json = data["words_json"].to_json
      data["words_json"] = json

      y, m, d =data["date"].split(".")

      data["date"] = Date.new(y.to_i,m.to_i,d.to_i)

      if data["id"]
        data["identifier"] = data.id
        data.reject!{ |k,v| k == "id" }
      end

      if data["text"]
        data["content"] = data["text"]
        data.reject!{ |k,v| k == "text"}
      end


      Session.create!(data)
      render :text => "created", :status => 201
    rescue Exception => ex
      logger.error(ex.message)
      logger.error(ex.backtrace.join("\r\n"))
      render :text => "error", :status => 401
    end
  end

  def index
    begin
        find_all
    rescue Exception => ex
      logger.error ex.message
      render :text => "error", :status => 401
    end
  end

  def show
    begin
      if params["identifier"]
        find_by_identifier(params["identifier"])
      elsif params[:id]
        find_by_id(params[:id])
      else
        find_all
      end
    rescue Exception => ex
      render :text => "error", :status => 401
    end
  end

  def destroy
    begin
      Session.destroy_all
      render :text => "destroyed", :status => 200
    rescue Exception => ex
      render :text => "error", :status => 401
    end
  end

  private

  def find_by_identifier(identifier)
    s = Session.find(:first, :conditions => { :identifier => identifier})
    render :json => s.to_json, :status => 200
  end

  def find_by_id(id)
    s = Session.find(id)
    if s
      render :json => s.to_json, :status => 200
    else
      render :text => "not_found", :status => 404
    end
  end

  def find_all
    render :json => Session.find(:all).map(&:to_hash).to_json, :status => 200
  end

end
