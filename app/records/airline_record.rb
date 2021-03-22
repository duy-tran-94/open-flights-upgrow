class AirlineRecord < ApplicationRecord
  self.table_name = 'airlines'
  has_many :reviews, class_name: 'ReviewRecord', foreign_key: :airline_id, dependent: :destroy

  validates :name, presence: true

  # Discussion: slugify and avg_score should be removed. Upgrow architecture
  # requires Records to be minimal and so avoids callbacks and instance methods.
  # slugify callback here could be an input transformation step, so it
  # could become a helper used in airline_input.rb
  before_create :slugify
  def slugify
    self.slug = name.parameterize
  end

  # Discussion: avg_score is meant to be used in an AirlineSerializer to include
  # average review score in responses. This is kept here because this demo does
  # not yet have a serializer layer, but this logic should be done in the Repository
  # layer and Action could use that Repo method, since serializers should serialize,
  # not querying
  def avg_score
    return 0 unless reviews.size.positive?

    reviews.average(:score).to_f.round(2)
  end
end
