class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :picture, PictureUploader

  # validate in addition to Devise
  validates :name, :first_name, presence: true
  validates :mobile,   presence: true,
            numericality: true,
            length:  { :minimum => 10, :maximum => 15 }


  has_many :products

end
