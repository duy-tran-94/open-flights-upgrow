class AirlineRepository < BaseRepository
  def all_with_reviews
    AirlineRecord.all.includes(:reviews).map do |record|
      # Discussion: one drawback of this implementation is the ugly boilerplate calls of to_model and
      # to_review_model. Probably equally verbose, but maybe directly initializing these Models (called Entity objects
      # here https://kellysutton.com/2019/10/29/taming-large-rails-codebases-with-private-activerecord-models.html)
      # would be more explicit
      reviews = record.reviews.map do |review_record|
        to_review_model(review_record.attributes)
      end
      to_model(record.attributes.merge(reviews: reviews))
    end
  end

  def find_by_slug_with_reviews(slug)
    record = AirlineRecord.includes(:reviews).find_by(slug: slug)

    reviews = record.reviews.map do |review_record|
      to_review_model(review_record.attributes)
    end

    to_model(record.attributes.merge(reviews: reviews))
  end

  def update_by_slug_with_reviews(slug, input)
    record = AirlineRecord.includes(:reviews).find_by(slug: slug)
    record.update!(input.attributes)

    reviews = record.reviews.map do |review_record|
      to_review_model(review_record.attributes)
    end

    to_model(record.attributes.merge(reviews: reviews))

  end

  def delete_by_slug(slug)
    AirlineRecord.find_by(slug: slug).destroy!
  end

  private

  # TODO: Should we let AirlineRepo touch Review Model?
  # What about exposing ReviewRepository.to_model, which is identical?
  def to_review_model(attributes)
    Review.new(**attributes.symbolize_keys)
  end
end