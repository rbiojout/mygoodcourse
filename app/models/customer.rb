class Customer < ActiveRecord::Base

  EMAIL_REGEX = /\A\b[A-Z0-9\.\_\%\-\+]+@(?:[A-Z0-9\-]+\.)+[A-Z]{2,6}\b\z/i
  PHONE_REGEX = /\A[+?\d\ \-x\(\)]{7,}\z/


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # add a file for image
  mount_uploader :picture, PictureUploader


  # Validations
  # validate in addition to Devise
  validates :name, :first_name, :mobile, presence: true
  validates :mobile,   format: { with: PHONE_REGEX }


  has_many :products, dependent: :destroy

  # We don't want to delete if some orders have been done
  has_many :orders, dependent: :restrict_with_exception



end
