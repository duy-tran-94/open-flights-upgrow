# frozen_string_literal: true

module Reviews
  class DeleteReviewAction < BaseAction
    def perform(id)
      ReviewRepo.delete(id)
      result.success
    end
  end
end