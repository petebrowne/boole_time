require 'rubygems'
require 'bundler/setup'
require 'active_record'
require 'boole_time'

ActiveRecord::Base.extend BooleTime
ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'
ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define(:version => 1) do
  create_table :posts do |t|
    t.timestamp :published_at
  end
end

class Post < ActiveRecord::Base
  boole_time :published_at
end
