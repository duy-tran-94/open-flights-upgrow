class ReviewRecord < ApplicationRecord
  # Discussion: First sign of trouble when straying from the Rails way. Since class names and table names are different
  # (reviews mapped to ReviewRecord), table_name needs to be specified, and all associations need to specify
  # class_name. Another possible way is to do has_many: review_records & belongs_to :airline_record, but things
  # quickly get complicated when the it's still airline_id in the Review Model and foreign key. airline_record_id
  # as a foreign key seems verbose, so it's probably best to either stick with Review and Airline for Records OR
  # to specify table_name and class_name every time
  self.table_name = 'reviews'
  belongs_to :airline, class_name: 'AirlineRecord'
end
