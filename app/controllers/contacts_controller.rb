class ContactsController < ApplicationController
  def index
    #  sort_attribute = params[:sort]
    if current_user  
      if params[:search_terms]
        @contacts = Contact.where("last_name LIKE ? and user_id=?", "%#{params[:search_terms]}%", current_user.id)
        render 'index.html.erb'    
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
    contact = Contact.new(
      first_name: params['first_name'],
      middle_name: params['middle_name'],
      last_name: params['last_name'],
      phone_number: params['phone_number'],
      email: params['email'],
      bio: params['bio'],
      user_id: current_user.id
    )
    contact.save
    flash[:success] = "Contact successfuly added"
    redirect_to '/contacts'
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
    contact = Contact.find_by(id: params['id'])
    contact.update(
      first_name: params['first_name'],
      middle_name: params['middle_name'],
      last_name: params['last_name'],
      email: params['email'],
      phone_number: params['phone_number']
    )
     flash[:success] = "Contact successfully updated"
    redirect_to "/contacts/#{contact.id}"
  end

  def destroy
    contact = Contact.find_by(id: params['id'])
    contact.destroy
    flash[:success] = "Product successfuly deleted"
    redirect_to "/contacts"
  end
end
