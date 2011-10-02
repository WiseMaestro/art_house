class ArtistsController < ApplicationController
  before_filter :auth, :except => [:show,:index, :alumni]
  before_filter :set_env
  def index
    @artists = Artist.find(:all, :order => 'name')
    @currentartists = @artists.find_all {|item| item.stillthere==1}
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artists }
    end
  end

  def alumni
    @artists = Artist.find(:all, :order => 'name')
    @alumni = @artists.find_all {|item| item.stillthere==0}
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artists }
    end
  end
  def show
    @artist = Artist.find(params[:id])
    @imgtag = ""
    if @artist.photo_file_name.nil?
        @imgtag = "NoImg.jpg"
    else
      @imgtag = @artist.photo.url
    end
    @sizex = @artist.sizex
    @sizey = @artist.sizey


    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @artist }
    end
  end

  def new
    if authenticate("creation")
    @artist = Artist.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @artist }
    end
    else
      permalt
    end
  end

  def edit
    if authenticate("priviledged")
    @artist = Artist.find(params[:id])
    else
      permalt
    end
  end

  def create
    account = authenticate("creation")
    if account
    @artist = Artist.new(params[:artist])


    respond_to do |format|
      if @artist.save
        

        # update account to reflect created artist
        if account.permission == -2
          account.update_attribute(:permission, 1)
          account.update_attribute(:artist, @artist.id)
        elsif account.permission == -1
          account.update_attribute(:permission, 0)
          account.update_attribute(:artist, @artist.id)
        end


        format.html { redirect_to(@artist, :notice => 'Artist was successfully created.') }
        format.xml  { render :xml => @artist, :status => :created, :location => @artist }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @artist.errors, :status => :unprocessable_entity }
      end
    end
    else
      permalt
    end
  end

  def update
        if authenticate("priviledged")
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
    else
          permalt
    end
  end

  def destroy
    if authenticate("priviledged")

    @artist = Artist.find(params[:id])
    @artist.destroy

    respond_to do |format|
      format.html { redirect_to(artists_url) }
    end
    else
      permalt
    end
  end
  
  def delete
        if authenticate("priviledged")

        else
          permalt
        end
  end
  
  def set_env
    @banner = "banner.jpg"
  end
  protected
  
  # def authenticate
  #   authenticate_or_request_with_http_basic do |user, password|
  #     for i in 1..1000 do
  #       password = Digest::SHA256.hexdigest(password)
  #     end
  #     if !(user == "admin" && password == "6a631dd57fc7f184b1e92a5ddea94076d1fb4c05341816201ce0454d79a04562")
  #       redirect_to(artists_path, :notice => "Sorry. You can't do that.")          
  #     else
  #       true
  #     end 
  #   end
  # end


    def permalt
        respond_to do |format|
          format.html { render(:controller => 'accounts', :action => "permission") }
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
            elsif account.artist == params[:id].to_i
              true
            else
              false
            end
        when "creation" #admin or negative artist
          if admin?(@permission)
            account
          elsif neg?(@permission)
            account
          else
            false
          end
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
