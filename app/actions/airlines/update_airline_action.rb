# frozen_string_literal: true

module Airlines
  class UpdateAirlineAction < BaseAction
    result :airline

    def perform(slug, input)
      if input.valid?
        airline = AirlineRepository.new.update_by_slug_with_reviews(slug, input)
        result.success(airline: airline)
      else
        result.failure(input.errors)
      end
    end
  end
end