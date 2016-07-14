class Contact < ActiveRecord::Base
  def friendly_time
    created_at.strftime('%A, %b %d')
  end

  def full_name
    first_name + " " + last_name
  end  
  
  def japan_number
    "+81" + phone_number
  end   

end