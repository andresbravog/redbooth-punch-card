class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, omniauth_providers: [:redbooth]

  serialize :credentials, Hash

  # Finds or creates user from omniauth info
  #
  # @param [type] ominiauth auth info object containing the user info
  # @return [User]
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid.to_s).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.credentials = auth.credentials || auth.extra.access_token.params
    end
  end

  # Udates user info when signing in
  #
  # @param [type] ominiauth auth info object containing the user info
  # @return [User]
  def update_from_omniauth(auth)
    update_attributes( email: auth.info.email,
                       credentials: auth.credentials || auth.extra.access_token.params )
  end
end
