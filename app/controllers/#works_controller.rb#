class WorksController < ApplicationController
  # GET /works
  # GET /works.xml
  before_filter :authenticate, :except => [:show,:index, :show_artist]
  before_filter :load_artists, :set_env

  
  def load_artists
    @artists = Artist.find(:all, :select => [:name, :id])    
  end
  def index
    @works = Work.all
    @workcount = @works.length
    @numperpage = 6
    @numperline = 3
    @locclose = 0
    unless (params[:list])
      @list = "1"
    else
      @list = params[:list]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @works }
    end
  end

  # GET /works/1
  # GET /works/1.xml
  def show
    @work = Work.find(params[:id])
    # @imgtag = "gallery/" + @work.name + ".jpg"
    # unless FileTest.exists?("#{RAILS_ROOT}/public/images/#{@imgtag}")
    #   @imgtag = "NoImg.jpg"
    # end
    @imgtag = @work.photo.url
    @sizex = @work.sizex
    @sizey = @work.sizey
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @work }
    end
  end
  
  def show_artist
    if params[:id].nil? then
        @works = Work.all
        @artid = nil
      else
        @artist = Artist.find(Integer(params[:id]))
        @works = @artist.works
        @test = 1
        @artid = Integer(params[:id])
    end
      @workcount = @works.length
      print "Workcount #{@workcount}"
      @numperpage = 6
      @numperline = 3
      @locclose = 0
        unless (params[:list])
          @list = "1"
        else
          @list = params[:list]
        end
        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render :xml => @works }
        end
  end

  # GET /works/new
  # GET /works/new.xml
  def new
    @work = Work.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @work }
    end
  end

  # GET /works/1/edit
  def edit
    @work = Work.find(params[:id])
  end

  # POST /works
  # POST /works.xml
  def create
    @work = Work.new(params[:work])

    respond_to do |format|
      if @work.save
        format.html { redirect_to(@work, :notice => 'Work was successfully created.') }
        format.xml  { render :xml => @work, :status => :created, :location => @work }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @work.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /works/1
  # PUT /works/1.xml
  def update
    @work = Work.find(params[:id])

    respond_to do |format|
      if @work.update_attributes(params[:work])
        format.html { redirect_to(@work, :notice => 'Work was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @work.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /works/1
  # DELETE /works/1.xml
  def destroy
    @work = Work.find(params[:id])
    @work.destroy

    respond_to do |format|
      format.html { redirect_to(works_url) }
      format.xml  { head :ok }
    end
  end

  def set_env
    @banner = "banner.jpg"
  end
  
  protected
  def self.encrypt(pass, salt)
    password = pass
    Digest::SHA256.hexdigest(pass+salt)
  end  

  def authenticate
    authenticate_or_request_with_http_basic do |user, password|
        for i in 1..1000 do
          password = Digest::SHA256.hexdigest(password)
        end
        #if  !(user == "admin" && password == "bar")
         if !(user == "admin" && password == "6a631dd57fc7f184b1e92a5ddea94076d1fb4c05341816201ce0454d79a04562")
          redirect_to(works_path, :notice => "Sorry. You can't do that.")
        else
          true
        end 
    end
end
end
