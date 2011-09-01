class AccountsController < ApplicationController
  before_filter :set_env

  def index
    authenticate("login")
    return
  end

  def new
     @account = Account.new
    respond_to do |format|
      format.html
      format.xml {render :xml => work }
    end
  end

  def edit
    @work = Work.find(params[:id])
  end

  def create
    @account = Account.new(params[:account])
    if authenticate("create")
      respond_to do |format|
      if @account.save
        format.html { redirect_to(:action => :index, :notice => 'Work was successfully created.') }
        flash[:message] = "Signup successful"
      else
        format.html { render :action => "new" }
        flash[:warning] = "Signup unsuccessful"
      end
        end
    end
  end

  def login
    authenticate("login")
    return
  end

  def logout
    reset_session
    flash[:message] = 'Logged out'
   end


  # def change_password
  #   authenticate("change_password")
  #   if request.post?
  #     @account.update_attributes(:password=>params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
  #     if @account.save
  #       flash[:message]="Password Changed"
  #     end
  #   end
  # end
 def set_env
    @banner = "banner.jpg"
  end
 

  protected



  protected
  def permissions(act, account)
    permission = account.permission
    if permission.nil?
      false
    else
      artist = account.artist
      if act == "create"
        if permission > 0
          true
        else
          false
        end
      elsif act == "delete"
        if permission > 1
          true
        else
          false
        end
      elsif act == "change_password"
        if account.id == params[:id]
          true
        else
          false
        end
      elsif act == "login"
        true
      else
        false     
      end
    end
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
# end authenticate_http
    else
      @match = Account.find_by_username(session[:username])
      if !(@match.hashedpass == session[:passhash])
        match = nil
      end
    end
    

    if @match.nil?
      false
    else
      permissions(action, @match)
    end


  end

end
