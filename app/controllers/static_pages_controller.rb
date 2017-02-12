class StaticPagesController < ApplicationController
  def home
    render layout: 'home'
  end

  def how_it_works
    render layout: 'home'
  end

  def help; end

  def contact; end

  def about
    render layout: 'home'
  end

  def cheating; end

  def components
    render layout: 'home'
  end

  def terms_and_conditions
    render layout: 'home'
  end
end
