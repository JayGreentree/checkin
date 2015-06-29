class User < ActiveRecord::Base
  has_many :checkin_session_owners, dependent: :destroy
  has_many :checkin_sessions, through: :checkin_session_owners
  has_many :checkins, class_name: "CheckinUser", dependent: :destroy

  scope :counselors, -> { where("title like ?", "%Counselor%") }
  scope :staff, -> { where("title like ? or title like ?", "%Counselor%", "%Director%") }
  belongs_to :partner, :class_name => "User"

  def ldap_reference
    @ldap_reference ||= CarnegieMellonPerson.find_by_andrewid( self.andrewid )
    # Add new attributes to CarnegieMellonPerson attributes before adding
    # references to them in participant.rb
  end

  def name
    Array.[](ldap_reference["cn"]).flatten.last
  end

  def given_name
    ldap_reference["givenName"]
  end
  
  def surname
    ldap_reference["sn"]
  end

  def email
    ldap_reference["mail"]
  end

  def department
    [ldap_reference["cmuDepartment"]].flatten.join(", ")
  end

  def departments
    ldap_reference["cmuDepartment"]
  end

  def student_class
    ldap_reference["cmuStudentClass"]
  end
  
end
