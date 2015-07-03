class UserCounselor < ActiveRecord::Base
  belongs_to :user
  belongs_to :counselor, class_name: "User"

  validates :user, uniqueness: { scope: :counselor }
  validates_presence_of :user, message: "required"
  validates_presence_of :counselor, message: "required"
end
