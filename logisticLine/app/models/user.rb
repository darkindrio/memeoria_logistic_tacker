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

  def has_alert?(alert_type, container_id, user_id)
    containerUser = ContainersUser.where(user_id: user_id, container_id: container_id).first
    if containerUser and containerUser.alerts
      alerts = containerUser.alerts.split(';')
      alerts.each do |alert|
        if alert == alert_type
          return true
        end
      end
      return false
    end
  end

end
