# frozen_string_literal: true

module Airlines
  class ShowAirlineAction < BaseAction
    result :airline

    def perform(slug)
      # Discussion: AirlineRecord is a private_constant in AirlineRepo module,
      # so accessing it from outside of AirlineRepo module will fail with a NameError
      # ("private constant AirlineRepo::AirlineRecord referenced")
      #
      # AirlineRepo::AirlineRecord.first
      result.success(airline: AirlineRepo.find_by_slug_with_reviews(slug))
    end
  end
end