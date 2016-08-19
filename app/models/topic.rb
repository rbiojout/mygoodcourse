class Topic < ActiveRecord::Base
  extend FriendlyId

  # we use slugs for finding the topics
  friendly_id :name, use: :slugged


  # linked to country with a position in the list
  belongs_to :country
  validates :country, :presence => true
  acts_as_list scope: :country, add_new_at: :bottom


  # associated to artcicles
  has_many :articles, dependent: :destroy
  accepts_nested_attributes_for :articles, reject_if: :all_blank, allow_destroy: true

  # order the articles from rails_admin
  def article_ids=(ids)
    unless (ids = ids.map(&:to_s)) == (current_ids = self.articles.map(&:_id).map(&:to_s))
      (current_ids - ids).each { |id| self.articles.select{|b|b.id.to_s == id}.first.remove }
      ids.each_with_index.map do |id, index|
        if current_ids.include?(id)
          (article = self.articles.select{|b|b.id.to_s == id}.first).position = (index+1)
        else
          b = Article.find(id)
          b.topic = self
          b.position = (index+1)
        end
      end
    end
  end


  validates :name, presence: true

  # we want a name with a Capital
  before_save :capitalize_name
  

  # ordered by the position by default
  default_scope -> { order(position: :asc) }

  # topics with articles
  scope :with_articles, -> { Topic.joins(:articles).distinct }

  private

  # we want a name that start with capital
  def capitalize_name
    self.name = self.name.capitalize
  end

end
