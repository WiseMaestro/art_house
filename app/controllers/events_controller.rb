class EventsController < ApplicationController
  # GET /events
  # GET /events.xml
  before_filter :auth, :except => [:show,:index]
  before_filter :set_env
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
   if auth 
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
   else
     permalt
   end
  end

  # GET /events/1/edit
  def edit
    if auth
    @event = Event.find(params[:id])
    else
      permalt
    end
end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    if auth
    respond_to do |format|
      if @event.save
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
    else
      permalt
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update

    @event = Event.find(params[:id])
    if auth
    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
    else
      permalt
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    if auth
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
    else
      permalt
    end
  end



  def delete
    if auth

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
  #       redirect_to(events_path, :notice => "Sorry. You can't do that.")
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
        when "isadmin"
            admin?(@permission)
        end
      end
    end
    def auth
      authenticate("isadmin")
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


end
