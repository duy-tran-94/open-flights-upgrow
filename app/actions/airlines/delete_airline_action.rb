# frozen_string_literal: true

module Airlines
  class DeleteAirlineAction < BaseAction
    def perform(slug)
      AirlineRepository.new.delete_by_slug(slug)
      result.success
    end
  end
end