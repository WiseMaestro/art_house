class ArtistsController < ApplicationController
  # GET /artists
  # GET /artists.xml
  before_filter :authenticate, :except => [:show,:index]
  def index
    @artists = Artist.find(:all, :order => 'name')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artists }
    end
  end

  # GET /artists/1
  # GET /artists/1.xml
  def show
    @artist = Artist.find(params[:id])
    @imgtag = "artists/" + @artist.name + ".jpg"
    unless FileTest.exists?("#{RAILS_ROOT}/public/images/#{@imgtag}")
      @imgtag = "NoImg.jpg"
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @artist }
    end
  end

  # GET /artists/new
  # GET /artists/new.xml
  def new
    @artist = Artist.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @artist }
    end
  end

  # GET /artists/1/edit
  def edit
    @artist = Artist.find(params[:id])
  end

  # POST /artists
  # POST /artists.xml
  def create
    @artist = Artist.new(params[:artist])

    respond_to do |format|
      if @artist.save
        format.html { redirect_to(@artist, :notice => 'Artist was successfully created.') }
        format.xml  { render :xml => @artist, :status => :created, :location => @artist }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /artists/1
  # PUT /artists/1.xml
  def update
    @artist = Artist.find(params[:id])

    respond_to do |format|
      if @artist.update_attributes(params[:artist])
        format.html { redirect_to(@artist, :notice => 'Artist was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /artists/1
  # DELETE /artists/1.xml
  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy

    #respond_to do |format|
    #  format.html { redirect_to(artists_url) }
    #  format.xml  { head :ok }
   # end
  end
  
  def delete
    
  end
  protected
  
  def authenticate
    authenticate_or_request_with_http_basic do |user, password|
        for i in 1..1000 do
          password = Digest::SHA256.hexdigest(password)
        end
         if !(user == "admin" && password == "6a631dd57fc7f184b1e92a5ddea94076d1fb4c05341816201ce0454d79a04562")
          redirect_to(artists_path, :notice => "Sorry. You can't do that.")          
        else
          true
        end 
    end
end
end
