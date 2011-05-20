class PagesController < ApplicationController
  def about
    @title = "About Us"
    @imgtag = "about.jpg"
  end

  def contact
    @title = "Contact Us"
    @imgtag = "contact.jpg"
  end

  def bios
    @title = "The Artists"
    @imgtag = "bios.jpg"
  end

  def gallery
    @title = "The Artwork"
    @imgtag = "gallery.jpg"
  end

  def events
    @title = "Events"
    @imgtag = "events.jpg"
  end

end
