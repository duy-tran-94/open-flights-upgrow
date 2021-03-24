# frozen_string_literal: true

module AirlineRepo
  class << self
    def create(input)
      airline = AirlineRecord.create!(input.attributes)
      to_model(airline.attributes)
    end

    def all_with_reviews
      AirlineRecord.all.includes(:reviews).map do |record|
        # Discussion: one drawback of this implementation is the ugly boilerplate calls of to_model and
        # to_review_model. Probably equally verbose, but maybe directly initializing these Models (called Entity objects
        # here https://kellysutton.com/2019/10/29/taming-large-rails-codebases-with-private-activerecord-models.html)
        # would be more explicit
        reviews = record.reviews.map do |review_record|
          to_review_model(review_record.attributes)
        end
        to_model(record.attributes.merge(reviews: reviews))
      end
    end

    def find_by_slug_with_reviews(slug)
      record = AirlineRecord.includes(:reviews).find_by(slug: slug)

      reviews = record.reviews.map do |review_record|
        to_review_model(review_record.attributes)
      end

      to_model(record.attributes.merge(reviews: reviews))
    end

    def update_by_slug_with_reviews(slug, input)
      record = AirlineRecord.includes(:reviews).find_by(slug: slug)
      record.update!(input.attributes)

      reviews = record.reviews.map do |review_record|
        to_review_model(review_record.attributes)
      end

      to_model(record.attributes.merge(reviews: reviews))

    end

    def delete_by_slug(slug)
      AirlineRecord.find_by(slug: slug).destroy!
    end

    private

    def to_model(attributes)
      Airline.new(**attributes.symbolize_keys)
    end

    def to_review_model(attributes)
      Review.new(**attributes.symbolize_keys)
    end

  end

  # Internal AirlineRecord
  class AirlineRecord < ApplicationRecord
    self.table_name = 'airlines'
    has_many :reviews, class_name: 'ReviewRepo::ReviewRecord', foreign_key: :airline_id, dependent: :destroy

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
  private_constant :AirlineRecord

end
