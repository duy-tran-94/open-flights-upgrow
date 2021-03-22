# frozen_string_literal: true

class ReviewInput < BaseInput
  attribute :title
  attribute :description
  attribute :score
  attribute :airline_id

  validates :airline_id, presence: true
end