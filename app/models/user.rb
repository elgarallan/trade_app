class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :stocks
  has_many :transactions

 # Admin role check
 def admin?
  admin
 end

  # Optional: define trader? for clarity (non-admins are considered traders here)
  def trader?
    !admin?
  end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end
end
