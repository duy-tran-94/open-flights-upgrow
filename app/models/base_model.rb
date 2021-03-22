# frozen_string_literal: true

class BaseModel < ImmutableObject
  attribute :id
  attribute :created_at
  attribute :updated_at

  def initialize(**args)
    # TODO: nil default added as a temp fix for missing attributes,
    # e.g. Airlines with & without associated Reviews)
    # This could produce unexpected problems, but not sure what or how
    self.class.attribute_names.each { |key| args.fetch(key, nil) }

    super
  end

  def to_param
    id.to_s
  end
end