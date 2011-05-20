class PagesController < ApplicationController
  def about
    @title = "About Us"
  end

  def contact
    @title = "Contact Us"
  end

  def bios
    @title = "The Artists"
  end

  def gallery
    @title = "The Artwork"
  end

  def events
    @title = "Events"
  end

end
