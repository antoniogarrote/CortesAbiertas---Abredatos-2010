class Api::ParliamentMembersController < ApplicationController

  def create
    data = ActiveSupport::JSON.decode(request.body.string)
    begin
      ParliamentMember.create!(data)
      render :text => "created", :status => 201
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
      else
        find_all_pms
      end
    rescue Exception => ex
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
    w = ParliamentMember.find(:first, :conditions => { :name => name})
    if w
      words_json = ActiveSupport::JSON.decode(w.words_json)
      render :json => {"name" => w.name, "words" => words_json}.to_json
    else
      render :text => "not_found", :status => 404
    end
  end

  def find_all_pms
    ws = ParliamentMember.find(:all)
    render :json => ws.map do |w|
      words_json = ActiveSupport::JSON.decode(w.words_json)
      {"name" => w.name, "words" => words_json}
    end.to_json
  end
end
