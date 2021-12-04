# Micro::Struct

Create powered Ruby structs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'u-struct'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install u-struct

## Usage

```ruby
# Like in a regular Struct, you can define one or many attributes.
# But all of will be required by default.

Micro::Struct.new(:first_name, :last_name, ...)

# Use the `optional:` arg if you want some optional attributes.

Micro::Struct.new(:first_name, :last_name, optional: :gender)

# Using `optional:` to define all attributes are optional.

Micro::Struct.new(optional: [:first_name, :last_name])

# Use the `required:` arg to define required attributes.

Micro::Struct.new(
  required: [:first_name, :last_name],
  optional: [:gender, :age]
)

# You can also pass a block to define custom methods.

Micro::Struct.new(:name) {}

# Available features (use one, many, or all) to create Structs with a special behavior:
# .with(:to_ary, :to_hash, :to_proc, :readonly, :instance_copy)

Micro::Struct.with(:to_ary).new(:name)
Micro::Struct.with(:to_ary, :to_hash).new(:name)
Micro::Struct.with(:to_ary, :to_hash, :to_proc).new(:name)
Micro::Struct.with(:to_ary, :to_hash, :to_proc, :readonly).new(:name)
Micro::Struct.with(:to_ary, :to_hash, :to_proc, :readonly, :instance_copy).new(:name)

# All of the possible combinations to create a Ruby Struct. ;)

Micro::Struct.new(*required)
Micro::Struct.new(*required) {}

Micro::Struct.new(optional: *)
Micro::Struct.new(optional: *) {}

Micro::Struct.new(required: *)
Micro::Struct.new(required: *) {}

Micro::Struct.new(*required, optional: *)
Micro::Struct.new(*required, optional: *) {}

Micro::Struct.new(required: *, optional: *)
Micro::Struct.new(required: *, optional: *) {}

# Any options above can be used by the `.new()` method of the struct creator returned by the `.with()` method.

Micro::Struct.with(*features).new(...) {}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/serradura/u-struct. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/serradura/u-struct/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Micro::Struct project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/serradura/u-struct/blob/master/CODE_OF_CONDUCT.md).
