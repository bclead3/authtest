# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :omniauthable, :registerable,                                #THESE WILL BE ADDED AT A LATER TIME...
         :recoverable, :rememberable, :trackable, :validatable, omniauth_providers: [:facebook]  #, :google_oauth2, :linkedin, :twitter

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :username, :provider, :uit, :avatar

  has_many :authentications, dependent: :delete_all

  validates :name, presence: true
  validates :email, presence: true

  def provider_authentication( provider = self.provider )
    Authentication.find_by_provider( provider )
  end

  def self.from_omniauth(auth)
    logger.debug "auth_in_User.class:#{auth.inspect}"
    if user = User.find_by_email(auth.info.email)
      unless user.provider == (auth.provider || auth.info.provider)
        user.provider = auth.provider ||= auth.info.provider
      end
      user.provider_authentication.uid = auth.uid
      user.provider_authentication.token = auth.token
      user.avatar = auth.info.image
      user.save
      user
    else
      where(auth.slice(:provider, :uid)).first_or_create do |user|
        user.provider = auth.provider ||= auth.info.provider
        user.uid = auth.uid || auth.info.uid
        user.username = auth.info.name ||= auth.info.nickname
        user.name = auth.info.name ||= auth.info.nickname
        user.email = auth.info.email
        user.avatar = auth.info.image
      end
    end
  end
end
