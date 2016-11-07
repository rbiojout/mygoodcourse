# == Schema Information
#
# Table name: forum_subjects
#
#  id                :integer          not null, primary key
#  name              :string
#  text              :text
#  customer_id       :integer
#  forum_category_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  counter_cache     :integer          default(0)
#
# Indexes
#
#  index_forum_subjects_on_customer_id        (customer_id)
#  index_forum_subjects_on_forum_category_id  (forum_category_id)
#
# Foreign Keys
#
#  fk_rails_d3d788b744  (forum_category_id => forum_categories.id)
#  fk_rails_f76a01a4d1  (customer_id => customers.id)
#

class ForumSubject < ActiveRecord::Base
  # follow activities
  # we explicitely indicate the reference because of rails_admin issues
  include Impressionist::IsImpressionable
  is_impressionable :counter_cache => true, :column_name => :counter_cache, :unique => :all

  belongs_to :customer
  belongs_to :forum_category

  has_many :forum_answers, dependent: :destroy

  # we have some likes that can be reported by customers
  has_many :likes, class_name: "Like", as: :likeable

  validates :name, :text, :forum_category, presence: true

  def last_activity_date
    if forum_answers.count >0
      forum_answers.last.created_at
    else
      created_at
    end
  end

  def last_activity_customer
    if forum_answers.count >0
      forum_answers.last.customer
    else
      customer
    end
  end

  def liked?(customer)
    Like.where(:likeable_id => self.id).where(:likeable_type => 'ForumSubject').where(:customer => customer).count > 0
  end


end
