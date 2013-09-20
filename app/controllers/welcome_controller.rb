class WelcomeController < ApplicationController

  def index
    render 'static_pages/home'
  end

  def about
    render 'static_pages/about'
  end
end