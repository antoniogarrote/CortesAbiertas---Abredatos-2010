class SessionsController < ApplicationController

  def index
    @sessions = Session.all
  end
end
