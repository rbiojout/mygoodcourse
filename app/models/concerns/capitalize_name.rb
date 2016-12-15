module CapitalizeName
  extend ActiveSupport::Concern

private

  # we want a name that start with capital
  def capitalize_name
    self.name = name.sub(/\S/, &:upcase) unless name.nil?
  end
end
