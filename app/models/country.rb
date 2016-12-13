# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string
#  code2      :string
#  code3      :string
#  continent  :string
#  tld        :string
#  currency   :string
#  eu_member  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Country < ActiveRecord::Base

  # we organize the products into cycles and levels for a country
  has_many :cycles
  has_many :levels, through: :cycles


  # we organize the products into families and levels for a country
  has_many :families
  has_many :categories, through: :families

  # we have help information for the country, there is no filter for the langage
  has_many :topics
  has_many :articles, through: :topics

  has_many :forum_families

  has_many :forum_categories, through: :forum_families

  # order the articles from rails_admin
  def topic_ids=(ids)
    unless (ids = ids.map(&:to_s)) == (current_ids = self.topics.map(&:id).map(&:to_s))
      # WARNING
      # the possibility to remove the topics is disabled
      #
      #(current_ids - ids).each { |id|
      #  topic_deleted = self.topics.select{|b|b.id.to_s == id}.first
      #  self.topics.delete(topic_deleted) unless topic_deleted.nil?
      #}
      #
      # initiate new_position
      new_position = 1
      ids.each_with_index.map do |id, index|
        if current_ids.include?(id)
          (topic = self.topics.select{|b|b.id.to_s == id}.first).position = (new_position)
          topic.save
          new_position = new_position + 1
        end
      end
    end
  end

end
