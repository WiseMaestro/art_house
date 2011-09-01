class AccountsController < ApplicationController
  before_filter :set_env
before_filter :admin_required, :only=>['create']
before_filter :login_required, :only=>['welcome', 'change_password', 'hidden']

  def create
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
    if request.post?
      if session[:user] = User.authenticate(params[:user][:login], params[:user][:password])
        flash[:message]  = "Login successful"
        redirect_to_stored
      else
        flash[:warning] = "Login unsuccessful"
      end
    end
  end

  def logout
    reset_session
    flash[:message] = 'Logged out'
    redirect_to :action => 'login'
  end


  def change_password
    @user=session[:user]
    if request.post?
      @user.update_attributes(:password=>params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
      if @user.save
        flash[:message]="Password Changed"
      end
    end
  end

  def welcome
  end
  def hidden
  end

  protected

  def authenticate
    unless (session[:user].nil? and session[:passhash].nil?)
      before_filter :login_required, :only=>['welcome', 'change_password', 'hidden']

  def signup
    @user = User.new(@params[:user])
    if request.post?  
      if @user.save
        session[:user] = User.authenticate(@user.login, @user.password)
        flash[:message] = "Signup successful"
        redirect_to :action => "welcome"          
      else
        flash[:warning] = "Signup unsuccessful"
      end
    end
  end

  def login
    if request.post?
      if session[:user] = User.authenticate(params[:user][:login], params[:user][:password])
        flash[:message]  = "Login successful"
        redirect_to_stored
      else
        flash[:warning] = "Login unsuccessful"
      end
    end
  end

  def logout
    session[:user] = nil
    flash[:message] = 'Logged out'
    redirect_to :action => 'login'
  end

  def forgot_password
    if request.post?
      u= User.find_by_email(params[:user][:email])
      if u and u.send_new_password
        flash[:message]  = "A new password has been sent by email."
        redirect_to :action=>'login'
      else
        flash[:warning]  = "Couldn't send password"
      end
    end
  end

  def change_password
    @user=session[:user]
    if request.post?
      @user.update_attributes(:password=>params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
      if @user.save
        flash[:message]="Password Changed"
      end
    end
  end

  def welcome
  end
  def hidden
  end
  protected

  def authenticate
  if (session[:username].nil? and session[:passhash].nil?)
    authenticate_or_request_with_http_basic do |user, password|
      passhash = Account.encrypt(user, password)
      match= Account.find_by_hashedpass(passhash)
   end
   
      if match.nil?
        redirect_to(:action => unpriviledged)
      else
        evaluate_permissions(action)
      end

  else

  end
end
