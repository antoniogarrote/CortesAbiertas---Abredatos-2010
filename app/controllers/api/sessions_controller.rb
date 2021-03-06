class Api::SessionsController < ApplicationController

  def index
    begin
        find_all
    rescue Exception => ex
      logger.error ex.message
      render :text => "error #{ex.message}", :status => 401
    end
  end

  def create
    return render :text => "unauthorized", :status => 401

    b = request.body.read
    data = ActiveSupport::JSON.decode(b)
    begin
      words = data.delete("words_json")

      if data["id"]
        data["identifier"] = data.id
        data.reject!{ |k,v| k == "id" }
      end

      if data["text"]
        data["content"] = data["text"]
        data.reject!{ |k,v| k == "text"}
      end


      s = Session.new(data)
      s.save!

      SessionWord.parse_words({ :session_id => s.id}, words)
      render :text => "created #{s.id}", :status => 201
    rescue Exception => ex
      logger.error(ex.message)
      logger.error(ex.backtrace.join("\r\n"))
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
    return render :text => "unauthorized", :status => 401
    begin
      if params[:id] == "*"
        Session.destroy_all
        Intervention.destroy_all
        SessionWord.destroy_all
        SessionWord.destroy_all
        InterventionWord.destroy_all
        ParliamentMember.destroy_all
        ParliamentMemberWord.destroy_all
      elsif params[:id]
        Session.find(params[:id]).interventions.destroy_all
        Session.find(params[:id]).session_words.destroy_all
        Session.find(params[:id]).destroy
      end
      render :text => "destroyed", :status => 200
    rescue Exception => ex
      logger.error("Error destroying session #{ex.message}")
      logger.error(ex.backtrace.join("\r\n"))
      render :text => "error", :status => 401
    end
  end

  private

  def find_by_identifier(identifier)
    s = Session.find(:first, :conditions => { :identifier => identifier})
    render :json => s.to_hash.to_json, :status => 200
  end

  def find_by_id(id)
    s = Session.find(id)
    if s
      render :json => s.to_hash.to_json, :status => 200
    else
      render :text => "not_found", :status => 404
    end
  end

  def find_all
    render :json => Session.find(:all).map(&:to_hash).to_json, :status => 200
  end

end
