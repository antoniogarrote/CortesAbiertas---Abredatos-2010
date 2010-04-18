class InterventionsController < ApplicationController

  def index
    @session = Session.find(params[:id])
    @interventions = @session.interventions
  end

end
