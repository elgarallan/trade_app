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

# (non-admins are considered traders here)
def trader?
  !admin?
 end
end