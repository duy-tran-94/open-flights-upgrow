# frozen_string_literal: true

module Api
  module V1
    class AirlinesController < ApplicationController
      def index
        airlines = Airlines::ListAirlinesAction.new.perform.airlines
        respond_to do |format|
          format.json { render json: airlines, status: :ok }
        end
        # Discussion: Adding a serialization layer
        # render json: AirlineSerializer.new(airlines).serialized_json
      end

      def show
        airline = Airlines::ShowAirlineAction.new.perform(params[:slug]).airline
        respond_to do |format|
          format.json { render json: airline, status: :ok }
        end
      end

      def create
        # Discussion: AirlineInput are used to validate airline_params immediately upon receipt,
        # this is nice but it bypasses any standard JSON error response serializer.
        # In the main app where input validation is done by Grape, this is simple:
        #       rescue_from Grape::Exceptions::ValidationErrors do |e|
        #         error!(GoogleJsonResponse.render_error(e), 422)
        #       end
        input = AirlineInput.new(airline_params)

        # TODO: if rendering with another lib, maybe no need for respond_to block
        respond_to do |format|
          Airlines::CreateAirlineAction.new.perform(input)
            .and_then do |airline:|
              format.json { render json: airline, status: :created }
            end
            .or_else do |errors|
              format.json { render json: errors, status: :unprocessable_entity }
            end
        end
      end

      def update
        input = AirlineInput.new(airline_params)

        respond_to do |format|
          Airlines::UpdateAirlineAction.new.perform(params[:slug], input)
            .and_then do |airline:|
              format.json { render json: airline, status: :ok }
            end
            .or_else do |errors|
              format.json { render json: errors, status: :bad_request }
            end
        end
      end

      def destroy
        Airlines::DeleteAirlineAction.new.perform(params[:slug])
          .and_then do
            head :no_content
          end
          .or_else do |errors|
            format.json { render json: errors, status: :unprocessable_entity }
          end
      end

      private

      def airline_params
        params.require(:airline).permit(:name, :image_url)
      end
    end
  end
end
