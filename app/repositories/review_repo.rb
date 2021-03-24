# frozen_string_literal: true

module ReviewRepo
  class << self
    def create(input)
      review = ReviewRecord.create!(input.attributes)
      to_model(review.attributes)
    end

    def delete(id)
      review = ReviewRecord.find(id)
      review.destroy!
    end

    private

    def to_model(attributes)
      Review.new(**attributes.symbolize_keys)
    end
  end

  # Internal ReviewRecord
  class ReviewRecord < ApplicationRecord
    # Discussion: First sign of trouble when straying from the Rails way. Since class names and table names are different
    # (reviews mapped to ReviewRecord), table_name needs to be specified, and all associations need to specify
    # class_name. Another possible way is to do has_many: review_records & belongs_to :airline_record, but things
    # quickly get complicated when the it's still airline_id in the Review Model and foreign key. airline_record_id
    # as a foreign key seems verbose, so it's probably best to either stick with Review and Airline for Records OR
    # to specify table_name and class_name every time
    self.table_name = 'reviews'
    belongs_to :airline, class_name: 'AirlineRepo::AirlineRecord'
  end
  private_constant :ReviewRecord

end