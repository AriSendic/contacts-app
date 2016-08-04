class ContactsController < ApplicationController
  def index
    #  sort_attribute = params[:sort]
    if current_user  
      if params[:search_terms]
        @contacts = Contact.where("user_id=? and last_name LIKE ? or first_name LIKE ? ", current_user.id, "%#{params[:search_terms]}%", "%#{params[:search_terms]}%")  
        render 'index.html.erb'    
      elsif params[:groups]
        @contacts = Group.find_by(name: params['groups']).contacts.where(user_id: current_user.id)
      else
        @contacts = current_user.contacts
        render 'index.html.erb'
      end
    else
      flash[:warning] = "You must be logged in to see this page!"
      redirect_to '/login'
    end
  end
  
  def new
    @contact = Contact.new
    render "new.html.erb"
  end

  def create
    latlong = Geocoder.coordinates(params[:address])
    if latlong
      computed_latitude = latlong[0]
      computed_longitude = latlong[1]
    else
      computed_latitude = nil
      computed_longitude = nil
    end   
    @contact = Contact.new(
      first_name: params['first_name'],
      middle_name: params['middle_name'],
      last_name: params['last_name'],
      phone_number: params['phone_number'],
      email: params['email'],
      bio: params['bio'],
      address: params['address'],
      latitude: computed_latitude,
      longitude: computed_longitude,
      user_id: current_user.id
    )
    if @contact.save
      flash[:success] = "Contact successfuly added"
      redirect_to '/contacts'
    else
      render "new.html.erb"
    end
  end
  
  def show
    @contact = Contact.find_by(id: params['id'])    
    render 'show.html.erb'
  end
  
  def edit
    @contact = Contact.find_by(id: params['id'])
    render 'edit.html.erb'
  end
  
  def update
    @contact = Contact.find_by(id: params['id'])
    if @contact.update(
      first_name: params['first_name'],
      middle_name: params['middle_name'],
      last_name: params['last_name'],
      email: params['email'],
      phone_number: params['phone_number']
    )
      flash[:success] = "Contact successfully updated"
      redirect_to "/contacts/#{@contact.id}"
    else
      render 'edit.html.erb' 
    end    
  end

  def destroy
    contact = Contact.find_by(id: params['id'])
    contact.destroy
    flash[:success] = "Product successfuly deleted"
    redirect_to "/contacts"
  end
end
