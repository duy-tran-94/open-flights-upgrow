# frozen_string_literal: true

module Reviews
  class DeleteReviewAction < BaseAction
    def perform(id)
      ReviewRepository.new.delete(id)
      result.success
    end
  end
end