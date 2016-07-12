class Country < ActiveRecord::Base
  has_many :cycles

  has_many :levels, through: :cycles


  has_many :families

  has_many :categories, through: :families

end
