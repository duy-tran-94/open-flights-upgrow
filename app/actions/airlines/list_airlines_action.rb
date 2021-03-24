# frozen_string_literal: true

module Airlines
  class ListAirlinesAction < BaseAction
    result :airlines

    def perform
      result.success(airlines: AirlineRepo.all_with_reviews)
    end
  end
end