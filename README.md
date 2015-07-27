# EagerCounting
Avoid N+1 Queries caused by `count` calls!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eager_counting'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eager_counting

## Usage

Include the `EagerCounting::CountBy` module on any `ActiveRecord` class.

```ruby
class Comment < ActiveRecord::Base
  include EagerCounting::CountBy
  belongs_to :author
  belongs_to :commentable, polymorphic: true
end
```

This will allow you to call `count_by` on scopes of this class.
`count_by` performs a count grouped by the given association.
This means it will return a hash mapping the ids of the associated objects
to the number of rows this class has for each of them.

### Examples:

```ruby
Comment.count_by(:author) # => hash with author id mapped to number of comments this user made
```

You can call this method on any relation object of the class you included it on

```ruby
Comment.where(spam: false).count_by(:author) # => will only count non spam comments
```

With the second argument you can also limit the scope of the association by which to count

```ruby
Comment.count_by(:author, User.where(admin: false)) # => only count comments by non admin users
```

By passing an hash as the association you can count by joined associations

```ruby
Comment.count_by(author: { city: :country }) # => count comments by the country their from
```

You can also use it on polymoprhic associations.
For that the second parameter is necessary to select the type of things to count by.

```ruby
Comment.count_by(:commentable, Picture.all) # => how many comments does each picture have?
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/foobar. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
