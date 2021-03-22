# frozen_string_literal: true

class AirlineInput < BaseInput
  attribute :name
  attribute :image_url

  validates :name, presence: true
end