module CapitalizeName
  extend ActiveSupport::Concern

  private
  # we want a name that start with capital
  def capitalize_name
    self.name = self.name.sub(/\S/, &:upcase) unless self.name.nil?
  end

end