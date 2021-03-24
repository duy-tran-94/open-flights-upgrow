# frozen_string_literal: true

module Airlines
  class CreateAirlineAction < BaseAction
    result :airline

    def perform(input)
      if input.valid?
        airline = AirlineRepo.create(input)
        result.success(airline: airline)
      else
        result.failure(input.errors)
      end
    end
  end
end