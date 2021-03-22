# frozen_string_literal: true

module Reviews
  class CreateReviewAction < BaseAction
    result :review

    def perform(input)
      if input.valid?
        review = ReviewRepository.new.create(input)
        result.success(review: review)
      else
        result.failure(input.errors)
      end
    end
  end
end