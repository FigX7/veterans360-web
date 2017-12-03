# == Schema Information
#
# Table name: partnering_organizations
#
#  id                     :integer          not null, primary key
#  name                   :string
#  phone_number           :string
#  website                :string
#  address                :string
#  lat                    :decimal(10, 6)
#  lng                    :decimal(10, 6)
#  role                   :integer
#  demographic            :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  approval_status        :boolean          default(false)
#
class PartneringOrganization < ApplicationRecord

	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	has_many :resources, :as => :owner, dependent: :destroy
  mount_uploader :image, ImageUploader

	enum role: [
		:caregiver,
		:support_team,
		:educator,
		:volunteer_organization,
		:awareness_team
	]

  enum demographic: [
		:active_duty,
		:veterans,
		:family_members,
		:children,
		:victims_of_violence,
		:suicide_prevention,
		:drugs_and_alcohol
	]

	geocoded_by :address, :latitude  => :lat, :longitude => :lng
	after_validation :geocode

  def active_for_authentication?
    super && approval_status?
  end

  def inactive_message
    if !approval_status?
      :not_approval_status
    else
      super # Use whatever other message
    end
  end
end
