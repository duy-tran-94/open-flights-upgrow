class Airline < BaseModel
  attribute :name
  attribute :slug
  attribute :image_url
  attribute :reviews

  class AssociationNotLoadedError < StandardError; end

  def reviews
    raise AssociationNotLoadedError if @reviews.nil?
    @reviews
  end
end