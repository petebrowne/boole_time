require 'rails/railtie'

module BooleTime
  class Railtie < Rails::Railtie
    initializer 'boole_time' do
      ActiveRecord::Base.extend BooleTime
    end
  end
end
