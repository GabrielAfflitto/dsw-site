class User < ActiveRecord::Base

  default_scope order('LOWER(name) ASC')

  attr_accessible :email,
                  :linkedin_uid,
                  :name,
                  :description

  attr_accessible :email,
                  :linkedin_uid,
                  :name,
                  :description,
                  :is_admin, as: :admin

  validates :name, presence: true
  validates :email, presence: true,
                    uniqueness: true

  has_many :submissions, foreign_key: 'submitter_id'
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :registrations, dependent: :destroy

  def self.find_or_create_from_auth_hash(auth_hash)
    user = User.where(linkedin_uid: auth_hash[:uid]).first_or_initialize
    user.update_attributes  linkedin_uid: auth_hash[:uid],
                            name:         auth_hash[:info][:name],
                            email:        auth_hash[:info][:email],
                            description:  auth_hash[:info][:description]
    user
  end

  def current_registration
    registrations.for_current_year.first
  end

end
