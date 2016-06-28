class User < ActiveRecord::Base
  has_many :checkin_session_owners, dependent: :destroy
  has_many :checkin_sessions, through: :checkin_session_owners
  has_many :checkins, class_name: "CheckinUser", dependent: :destroy

  has_many :user_counselors, dependent: :destroy
  has_many :counselors, through: :user_counselors

  has_many :user_residents, dependent: :destroy, class_name: "UserCounselor", foreign_key: "counselor_id"
  has_many :residents, through: :user_residents, source: :user
  
  belongs_to :partner, :class_name => "User"
  belongs_to :program

  validates_presence_of :andrewid, message: "required"
  validates_uniqueness_of :andrewid, message: "already exists"

  scope :counselors, -> { where( "staff = ? and admin = ?", true, false ) }
  scope :admins, -> { where( admin: true ) }
  scope :staff, -> { where( staff: true ) }

  def staff?
    self.staff
  end

  def self.find_andrew_user search_string
    u = self.find_by_andrewid search_string
    u ||= self.find_or_create_by( andrewid: CarnegieMellonIDCard.search( search_string ) )
    unless u.validate(:andrewid)
      u = self.find_or_create_by( andrewid: CarnegieMellonPerson.
                       find_by_andrewid( search_string )[:cmuandrewid] )
    end
    u
  rescue ActiveLdap::EntryNotFound
  end


  def ldap_reference
    @ldap_reference ||= CarnegieMellonPerson.find_by_andrewid( self.andrewid )
    # Add new attributes to CarnegieMellonPerson attributes before adding
    # references to them in participant.rb
  end

  def name
   self.name_cache || Array.[](ldap_reference["cn"]).flatten.last
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
