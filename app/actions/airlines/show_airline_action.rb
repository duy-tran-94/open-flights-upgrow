# frozen_string_literal: true

module Airlines
  class ShowAirlineAction < BaseAction
    result :airline

    def perform(slug)
      result.success(airline: AirlineRepository.new.find_by_slug_with_reviews(slug))
    end
  end
end