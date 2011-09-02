class AccountsController < ApplicationController
  before_filter :set_env
  before_filter :auth
  def index
    @ident = authenticate("get_id")
  end

  def new
    @account = Account.new
    if authenticate("create")
      respond_to do |format|
       format.html
      end
    else
      respond_to do |format|
        format.html { render :action => 'permission' }
      end
    end    
  end

  def makeadmin
    @account = Account.find(params[:id])
    @permission = authenticate('makeadmin')
      unless @account.nil?
    if @permission and (@account.permission > -1) and (1 > @account.permission)
      
      @account.update_attribute(:permission, 1)
      respond_to do |format|
        format.html { redirect_to :action => 'list' }
      end
    else
      permalt
    end
  else
    permalt
  end
end
def makesuper
  @account = Account.find(params[:id])
  unless @account.nil?
    @permission = authenticate('makesuper')
    if @permission and (@account.permission > -1)
      @account.update_attribute(:permission, 2)
      respond_to do |format|
        format.html { redirect_to :action => 'index' }
      end
    else
      permalt
    end
  else
    permalt
  end
end

def changepassword
        @account = Account.find(params[:id])
  unless @account.nil?
    id = authenticate('get_id')
    if id = params[:id].to_i
      respond_to do |format|
        format.html
      end
    else
      permalt
    end
  else
    permalt
  end

end


  def updater
      @account = Account.find(params[:account])
    if authenticate("get_id").to_i == @account.id
        respond_to do |format|
          if @account.save
            format.html { redirect_to :action => "index" }
            flash[:message] = "Signup successful"
          else
            format.html { render :action => "new" }
            flash[:warning] = "Signup unsuccessful"
          end
        end
      else
        permalt
      end
    end

  def update
      @account = Account.find(params[:id])
      if true
        respond_to do |format|
          if @account.update_attributes(params[:account])
            format.html { redirect_to :action => "index" }
            flash[:message] = "Signup successful"
          else
            format.html { render :action => "changepassword" }
            flash[:warning] = "Signup unsuccessful"
          end
        end
      else
        permalt
      end
    end


    def create
      @account = Account.new(params[:account])
      if authenticate("create")
        respond_to do |format|
          if @account.save
            format.html { redirect_to :action => "index" }
            flash[:message] = "Signup successful"
          else
            format.html { render :action => "new" }
            flash[:warning] = "Signup unsuccessful"
          end
        end
      else
        permalt
      end
    end

    def login
      authenticate("login")
      respond_to do |format|
        format.html { render :action => "index" }
      end
    end

    def list
      if authenticate("list")
        @accounts = Account.find(:all)
      else
        permalt
      end
    end
  
    def delete

    end

    def permission

    end

    def destroy
      @permission = authenticate("delete")
      if @permission
        @account = Account.find(params[:id])
        @account.destroy
        respond_to do |format|
          format.html { redirect_to :action => 'list' }
        end
      else
        permalt
      end
    end

    def logout
      session[:username] = nil
      session[:passhash] = nil
      reset_session
      redirect_to("/pages/about", :notice => 'Logged out')
    end

    
    


    def set_env
      @banner = "banner.jpg"
    end
    

    protected

    def permalt
        respond_to do |format|
          format.html { render(:action => "permission") }
        end
    end


    def permissions(act, account)
      @permission = account.permission
      if @permission.nil?
        false
      else
        artist = account.artist
        case act
        when "create"
          if @permission > 0
            true
          else
              false
          end
        when "delete"
          if @permission > 1
            @permission
          else
            false
          end
        when "get_id"
          account.id
        when "login"
          true
        when "list"
          if @permission > 0
            true
          else
            false
          end
        when "makeadmin"
          if @permission > 0
            @permission
          else
            false
          end
        when "makesuper"
          if @permission > 1
            @permission
          else
            false
          end
       
        else
          false     
        end
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
        true
      else
        false
      end
    end
  end
