class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #has_many :alert_subscribes
  #has_many :containers, :through => :alert_subscribes

  has_and_belongs_to_many :containers

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  Roles = [ :admin , :default ]

  def is?( requested_role )
    self.role == requested_role.to_s
  end

  def has_alert?(alert_type, container)
    #!!alert_subscribes.where(notification_type: alert_type).where(container_id: container.id).first
  end

end
