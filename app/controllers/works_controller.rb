class WorksController < ApplicationController
  # GET /works
  # GET /works.xml
  before_filter :auth, :except => [:show,:index, :show_artist]
  before_filter :load_artists, :set_env
 def set_env
    @banner = "banner.jpg"
  end
  
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

  def new
    account = authenticate("get_account")
    if account.artist > 0
    @account_artist = account.artist
    @work = Work.new
    respond_to do |format|
      format.html # new.html.erb
    end
    else
      permalt
    end
  end

  def edit
    if authenticate("priviledged")
     @work = Work.find(params[:id])
    else
      permadm
    end
  end

  def create
    account = authenticate("get_account")
    if account.artist > 0
    @work = Work.new(params[:work])

    respond_to do |format|
      if @work.save
        format.html { redirect_to(@work, :notice => 'Work was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
    else
      permalt
    end
  end

  def update
    if authenticate("priviledged")
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
    else
      permadm
    end
  end

  def delete
    if authenticate("priviledged")
      
    else
      permadm
    end
  end

  def destroy
    if authenticate("priviledged")
    @work = Work.find(params[:id])
    @work.destroy
    respond_to do |format|
      format.html { redirect_to(works_url) }
      format.xml  { head :ok }
    end
    else
      permalt
    end
  end

  
  protected
#   def self.encrypt(pass, salt)
#     password = pass
#     Digest::SHA256.hexdigest(pass+salt)
#   end  

#   def authenticate
#     authenticate_or_request_with_http_basic do |user, password|
#         for i in 1..1000 do
#           password = Digest::SHA256.hexdigest(password)
#         end
#         #if  !(user == "admin" && password == "bar")
#          if !(user == "admin" && password == "6a631dd57fc7f184b1e92a5ddea94076d1fb4c05341816201ce0454d79a04562")
#           redirect_to(works_path, :notice => "Sorry. You can't do that.")
#         else
#           true
#         end 
#     end
# end




    def permalt
        respond_to do |format|
          format.html { render(:controller => 'accounts', :action => "permission") }
        end
    end
        def permadm
        respond_to do |format|
          format.html { render(:controller => 'accounts', :action => "permadm") }
        end
    end


    def permissions(act, account)
      @permission = account.permission
      if @permission.nil?
        false
      else
        artist = account.artist
        case act
        when "login"
          true
        when "priviledged" # is admin or artist
            if admin?(@permission)
              true
            elsif account.artist == Work.find(params[:id]).artist.id
              true
            else
              false
            end
        when "get_account"
            account
        end #case end
        
      end
    end
    def auth
      authenticate("login")
    end
    def authenticate(action)
      @match = nil
      if (session[:username].nil? or session[:passhash].nil?)
        authenticate_or_request_with_http_basic do |user, password|
          @match= Account.find_by_username(user)


          passhash = "xxxxxxxxxx"
          unless @match.nil?
            passhash = Account.encrypt(password, @match.salt)
            if !(@match.hashedpass == passhash)
              @match = nil
            else
              session[:username] = user
              session[:passhash] = passhash
            end
          else
            @match = nil

          end
        end
        # above end authenticate_http
      else
        @match = Account.find_by_username(session[:username])
        unless @match.nil?
        if !(@match.hashedpass == session[:passhash])
          match = nil
        end
          end
      end
      

      if @match.nil?
        false
      else
        if action.nil?
          action= "login"
        end
        permissions(action, @match)
      end


    end

    def su?(permission)
      if permission == 2
        true
      else
        false
      end
    end
    def admin?(permission)
      if permission == 1 or permission == 2
        return true
      else
        return false
      end
    end
    def neg?(permission)
      if permission == -1 or permission == -2
        return true
      else
        return false
      end
    end



end
