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
      name         = options[:name] || field.to_s.sub(/_(at|on)\z/, '')
      negative     = options[:negative] || "un#{name}"
      truthy_scope = options[:truthy_scope] || name
      falsy_scope  = options[:falsy_scope] || negative

      # Define truthy scope
      scope(truthy_scope, Proc.new {
        where(arel_table[field].lt(Time.now))
      }) unless options[:truthy_scope] == false

      # Define falsy scope
      scope(falsy_scope, Proc.new {
        where(arel_table[field].eq(nil).or(arel_table[field].gt(Time.now)))
      }) unless options[:falsy_scope] == false

      # Define writer method
      mixin.redefine_method(:"#{name}=") do |value|
        if TRUE_VALUES.include?(value)
          __send__(:"#{field}=", Time.now) if __send__(field).nil?
        else
          __send__(:"#{field}=", nil)
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
  ActiveRecord.extend BooleTime
elsif defined?(Rails)
  require 'boole_time/railtie'
end
