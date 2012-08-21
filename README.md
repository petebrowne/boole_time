# BooleTime

ActiveRecord plugin for creating a boolean virtual attribute and scopes from
a date or date_time column.

## Getting Started

``` ruby
# Gemfile
gem 'boole_time'
```

``` bash
$ bundle install
$ rails generate model Post published_at:datetime
# Or any model with a datetime column
```

```ruby
# app/models/post.rb
class Post < ActiveRecord::Base
  boole_time :published_at
end

# elsewhere
post = Post.new
post.published = true
post.published_at
# => (Time.now)
post.published = false
post.published_at
# => nil
```

## Copyright

Copyright (c) 2012 [Pete Browne](http://petebrowne.com). See LICENSE for details.
