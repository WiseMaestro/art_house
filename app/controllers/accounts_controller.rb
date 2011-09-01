class AccountsController < ApplicationController
  before_filter :set_env

  def index
    authenticate("login")
    return
  end


  def create
    authenticate("create")
    respond_to do |format|
      @account = Account.new(@params[:account])
      if @account.save
        flash[:message] = "Signup successful"
      else
        flash[:warning] = "Signup unsuccessful"
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
        passhash = Account.encrypt(user, password)
        @match= Account.find_by_username(user)
        if @match.nil? or !(@match.hashedpass == passhash)
          @match = nil
        else
          session[:username] = user
          session[:passhash] = passhash
        end
      end
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
