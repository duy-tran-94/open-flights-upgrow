module Api
  module V1
    class ReviewsController < ApplicationController
      def create
        input = ReviewInput.new(review_params)

        # TODO: if rendering with another lib, maybe no need for respond_to block
        respond_to do |format|
          Reviews::CreateReviewAction.new.perform(input)
            .and_then do |review:|
              format.json { render json: review, status: :created }
            end
            .or_else do |errors|
              format.json { render json: errors, status: :unprocessable_entity }
            end
        end
      end

      def destroy
        Reviews::DeleteReviewAction.new.perform(params[:id])
          .and_then do
            head :no_content
          end
          .or_else do |errors|
            format.json { render json: errors, status: :unprocessable_entity }
          end
      end

      private

      def review_params
        params.require(:review).permit(:title, :description, :score, :airline_id)
      end
    end
  end
end