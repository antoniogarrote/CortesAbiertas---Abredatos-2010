class Api::ParliamentMembersController < ApplicationController

  def index
    begin
      render :json => ParliamentMember.find(:all).map(&:to_hash).to_json, :status => 200
    rescue Exception => ex
      logger.error ex.message
      render :text => "error #{ex.message}", :status => 401
    end
  end

  def create
    data = ActiveSupport::JSON.decode(request.body.read)

    begin
      words = data.delete("words_json")


      mp = ParliamentMember.find(:first, :conditions => { :name => data["name"] })
      if mp.nil?
        mp = ParliamentMember.new(data)
        mp.save!
      else
        to_add = []
        mp.parliament_member_words.each do |w|
          present = words.detect{ |ow| ow["stem"] == w.stem && ow["pos"] == w.pos }
          if present
            w.count += present["count"]
          else
            to_add << w
          end
        end
        to_add.each{ |taw| mp.parliament_member_words << taw }
        mp.save!
      end

      render :text => "created #{mp.id}", :status => 201
    rescue Exception => ex
      logger.error(ex.message)
      logger.error(ex.backtrace.join("\r\n"))
      render :text => "error", :status => 401
    end
  end

  def show
    begin
      if params[:name]
        find_pm(params[:name])
      elsif params[:id]
        render :json => ParliamentMember.find(params[:id]).to_hash.to_json, :status => 200
      end
    rescue Exception => ex
      logger.error("Error: #{ex.message}")
      logger.error(ex.backtrace.join("\r\n"))
      render :text => "error", :status => 401
    end
  end

  def destroy
    begin
      ParliamentMember.destroy_all
      render :text => "destroyed", :status => 200
    rescue Exception => ex
      render :text => "error", :status => 401
    end
  end

  private

  def find_pm(name)
    pm = ParliamentMember.find(:first, :conditions => { :name => name })
    if pm
      render :json => pm.to_hash.to_json, :status => 200
    else
      render :text => "not_found", :status => 404
    end
  end

  def find_all_pms
    render :json => ParliamentMember.find(:all).map{ |pm| pm.to_hash }.to_json, :status => 200
  end
end
