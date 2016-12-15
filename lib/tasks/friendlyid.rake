##
# generated with rails g task friendlyid add_slugs
# use rake friendlyid:add_slugs RAILS_ENV=development
##
namespace :friendlyid do
  desc 'Add slugs to products'
  task add_slugs: :environment do
    Product.find_each(&:save)
    Customer.find_each(&:save)
  end
end
