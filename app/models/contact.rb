class Contact < ActiveRecord::Base
  belongs_to :user
  has_many :contact_groups
  has_many :groups, through: :contact_groups
  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, uniqueness: true
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