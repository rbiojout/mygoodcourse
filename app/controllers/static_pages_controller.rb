class StaticPagesController < ApplicationController
  def home
    render layout: 'home'
  end

  def help
  end

  def contact
  end

  def about
    render layout: 'home'
  end

  def cheating
  end
end
