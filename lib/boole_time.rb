require 'boole_time/version'

module BooleTime
  TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE', 'on', 'ON'].freeze

  # Creates a boolean attribute that corresponds to a date or date_time
  # attribute. For instance:
  #
  #   class Post < ActiveRecord::Base
  #     boole_time :published_at
  #   end
  #
  # Generates these methods:
  #
  #   post.published = true
  #   # sets published_at to Time.now
  #   post.published
  #   # => true
  #   post.published = false
  #   # sets published_at to nil
  #   post.published?
  #   # => false
  #
  def boole_time(*fields)
    options = fields.extract_options!
    mixin   = generated_feature_methods

    fields.each do |field|
      name        = options[:name]        || field.to_s.sub(/_(at|on)\z/, '')
      negative    = options[:negative]    || "un#{name}"
      true_scope  = options[:true_scope]  || name
      false_scope = options[:false_scope] || negative

      unless options[:scopes] == false
        # Define truthy scope
        scope(true_scope, Proc.new {
          where(arel_table[field].lt(Time.now))
        }) unless options[:true_scope] == false

        # Define falsy scope
        scope(false_scope, Proc.new {
          field_attr = arel_table[field]
          where(field_attr.eq(nil).or(field_attr.gt(Time.now)))
        }) unless options[:false_scope] == false
      end

      # Define writer method
      mixin.redefine_method(:"#{name}=") do |value|
        if TRUE_VALUES.include?(value)
          __send__(:"#{field}=", Time.now) unless __send__(name)
        else
          __send__(:"#{field}=", nil) if __send__(name)
        end
      end

      # Define reader and query methods
      mixin.redefine_method(name) do
        value = __send__(field)
        value.present? && value < Time.now
      end
      mixin.redefine_method(:"#{name}?") { __send__(name) }

      # Define negative reader and query methods
      unless options[:negative] == false
        mixin.redefine_method(negative)        { !__send__(name) }
        mixin.redefine_method(:"#{negative}?") { !__send__(name) }
      end
    end
  end
end

if defined?(ActiveRecord)
  ActiveRecord::Base.extend BooleTime
elsif defined?(Rails)
  require 'boole_time/railtie'
end
