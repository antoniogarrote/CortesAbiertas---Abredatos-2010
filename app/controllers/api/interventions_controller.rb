class Api::InterventionsController < ApplicationController
  def create
    data = ActiveSupport::JSON.decode(request.body.read)
    begin
      json = data["words_json"].to_json
      data["words_json"] = json

      y, m, d =data["date"].split(".")
      data["date"] = Date.new(y.to_i,m.to_i,d.to_i)

      if data["parliament_member"]
        pm = ParliamentMember.find(:first, :conditions => { :name => data["parliament_member"]})
        if pm.nil?
          raise Exception.new "Parliament Member non existent #{data["parliament_member"]}"
        else
          data["parliament_member_id"] = pm.id
          data.reject!{ |k,v| k == "parliament_member" }
        end
      end

      if data["text"]
        data["content"] = data["text"]
        data.reject!{ |k,v| k == "text"}
      end


      Intervention.create!(data)
      render :text => "created", :status => 201
    rescue Exception => ex
      logger.error(ex.message)
      logger.error(ex.backtrace.join("\r\n"))
      render :text => "error", :status => 401
    end
  end

  def show
    begin
      if params["parliament_member_id"]
        find_by_orator_id(params["parliament_member_id"])
      elsif params["parliament_member"]
        find_by_orator_name(params["parliament_member"])
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
      Intervention.destroy_all
      render :text => "destroyed", :status => 200
    rescue Exception => ex
      render :text => "error", :status => 401
    end
  end

  private

  def find_by_orator_id(orator_id)
    interventions = Intervention.find(:all, :conditions => { :parliament_member_id => orator_id})
    render :json => interventions.map(&:to_hash).to_json, :status => 200
  end

  def find_by_orator_name(orator_name)
    interventions = Intervention.find_by_sql ["SELECT * from interventions i, parliament_members p where i.parliament_member_id=p.id and p.name = ?", orator_name]
    render :json => interventions.map(&:to_hash).to_json, :status => 200
  end

  def find_by_id(id)
    intervention = Intervention.find(id)
    if intervention
      render :json => intervention.to_json, :status => 200
    else
      render :text => "not found", :status => 404
    end
  end

  def find_all
    render :json => Intervention.find(:all).map(&:to_hash).to_json, :status => 200
  end

end
