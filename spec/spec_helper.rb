require 'rubygems'
require 'bundler/setup'
require 'active_record'
require 'boole_time'
require 'timecop'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'
ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define(:version => 1) do
  create_table :posts do |t|
    t.datetime :published_at
    t.datetime :deleted_at
    t.date     :subscribed_on
    t.date     :comments_closed_on
  end
end

class Post < ActiveRecord::Base
  boole_time :published_at
  boole_time :deleted_at, name: 'trashed', negative: 'treasured'
  boole_time :subscribed_on, scopes: false, negative: false
  boole_time :comments_closed_on, true_scope: 'with_comments_closed', false_scope: 'with_comments_open'
end

RSpec.configure do |config|
  config.before(:all) do
    Timecop.freeze
  end
end
