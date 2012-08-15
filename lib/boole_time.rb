require 'boole_time/version'

module BooleTime
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
    fields.each do |field|
      name = options[:name] || field.to_s.sub /_(at|on)\z/, ''

      define_method(name) do
        read_attribute(field).present?
      end
      alias_method "#{name}?", name

      define_method("#{name}=") do |value|
        if ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(value)
          write_attribute(field, Time.now)
        else
          write_attribute(field, nil)
        end
      end
    end
  end
end

if defined?(ActiveRecord)
  ActiveRecord.extend BooleTime
elsif defined?(Rails)
  require 'boole_time/railtie'
end
