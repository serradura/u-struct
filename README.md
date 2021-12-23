<p align="center">
  <h1 align="center">🧱 μ-struct</h1>
  <p align="center"><i>Create powered Ruby structs.</i></p>
  <br>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/ruby%20%3E=%202.2,%20%3C%203.2-ruby.svg?colorA=99004d&colorB=cc0066" alt="Ruby">
  <a href="https://rubygems.org/gems/u-struct">
    <img alt="Gem" src="https://img.shields.io/gem/v/u-struct.svg?style=flat-square">
  </a>
  <a href="https://github.com/serradura/u-struct/actions/workflows/ci.yml">
    <img alt="Build Status" src="https://github.com/serradura/u-struct/actions/workflows/ci.yml/badge.svg">
  </a>
  <a href="https://codeclimate.com/github/serradura/u-struct/maintainability">
    <img alt="Maintainability" src="https://api.codeclimate.com/v1/badges/2cc0204411cc2b392b7a/maintainability">
  </a>
  <a href="https://codeclimate.com/github/serradura/u-struct/test_coverage">
    <img alt="Test Coverage" src="https://api.codeclimate.com/v1/badges/2cc0204411cc2b392b7a/test_coverage">
  </a>
</p>

# Table of contents: <!-- omit in toc -->
- [Introduction](#introduction)
  - [Project Motivation](#project-motivation)
- [Installation](#installation)
- [Usage](#usage)
  - [`Micro::Struct.new`](#microstructnew)
    - [`optional:` option](#optional-option)
    - [`required:` option](#required-option)
    - [Defining custom methods/behavior](#defining-custom-methodsbehavior)
  - [`Micro::Struct.with`](#microstructwith)
    - [`:to_ary`](#to_ary)
    - [`:to_hash`](#to_hash)
    - [`:to_proc`](#to_proc)
    - [`:readonly`](#readonly)
    - [`:instance_copy`](#instance_copy)
    - [`:exposed_features`](#exposed_features)
  - [`Micro::Struct.instance()` or `Micro::Struct.with(...).instance()`](#microstructinstance-or-microstructwithinstance)
  - [TL;DR](#tldr)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)

## Introduction

Ruby Struct is a versatile data structure because it can behave like an Array, Hash, and ordinary object. e.g.

```ruby
Person = Struct.new(:first_name, :last_name)

person = Person.new('Rodrigo', 'Serradura')
# #<struct Person first_name="Rodrigo", last_name="Serradura">

# -- Ordinary object behavior --

person.first_name # "Rodrigo"
person.last_name  # "Serradura"

person.first_name = 'John' # "John"
person.last_name = 'Doe'   # "Doe"

person
# #<struct Person first_name="John", last_name="Doe">

# -- Hash behavior --

person[:first_name] # "Doe"
person['last_name'] # "John"

person[:first_name] = 'Rodrigo'   # "Rodrigo"
person['last_name'] = 'Serradura' # "Serradura"

person
# #<struct Person first_name="Rodrigo", last_name="Serradura">


# Transforming a Struct into a Hash
person.to_h
# {:first_name=>"Rodrigo", :last_name=>"Serradura"}

# -- Array behavior --

person[0] # "Rodrigo"
person[1] # "Serradura"

person[0] = 'John' # "John"
person[1] = 'Doe'  # "Doe"

person
# #<struct Person first_name="John", last_name="Doe">

# Transforming a Struct into an Array
person.to_a
# ["John", "Doe"]
```

Because of these characteristics, structs could be excellent candidates to create different kinds of POROs (Plain Old Ruby Objects). But, it is very common to see developers avoiding its usage because of some of its behaviors, like setters or the constructor's positional arguments. The addition of keywords arguments on its constructor ([available on Ruby >= 2.5](https://www.bigbinary.com/blog/ruby-2-5-allows-creating-structs-with-keyword-arguments)) improved the experience to instantiate Struct objects. But, as it doesn't require all the arguments, some developers can still avoid its usage.

Look at the example showing the Struct's `keyword_init:` option creating a constructor with optional keyword arguments:

```ruby
Person = Struct.new(:first_name, :last_name, keyword_init: true)

Person.superclass # Struct

Person.new
# #<struct Person first_name=nil, last_name=nil>

# Because of this, you will only see an exception
# if you pass one or more invalid keywords.

Person.new(foo: 1, bar: 2)
# ArgumentError (unknown keywords: foo, bar)
```

### Project Motivation

So, given this introduction, the idea of this project is to provide a way of creating Ruby Structs with some [powerful features](#microstructwith).  And to start, let's see how the `Micro::Struct.new()` works.

```ruby
require 'u-struct'

Person = Micro::Struct.new(:first_name, :last_name)

Person.superclass
# Struct

Person.new
# ArgumentError (missing keywords: :first_name, :last_name)
```

As you can see, the struct instantiation raised an error because all of the keywords arguments are required.

But, if you need one or many optional arguments, you can use the `optional:` option to define them. e.g.

```ruby
Person = Micro::Struct.new(:first_name, optional: :last_name)

Person.new
# ArgumentError (missing keyword: :first_name)

Person.new(first_name: 'Rodrigo')
# #<struct Person first_name="Rodrigo", last_name=nil>
```

If you want a Struct only with optional members (or attributes), as the `keyword_init:` option does.

You can declare all attributes within the `optional:` option.

```ruby
Person = Micro::Struct.new(optional: [:first_name, :last_name])

Person.new
# #<struct Person first_name=nil, last_name=nil>
```

You can also use the `required:` option to define required attributes.

```ruby
Person = Micro::Struct.new(
  required: [:first_name, :last_name],
  optional: [:age]
)
```

So, what did you think? If you liked it, continue the reading to understand what this gem can do for you.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'u-struct'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install u-struct

[⬆️ &nbsp;Back to Top](#table-of-contents-)

## Usage

### `Micro::Struct.new`

Like `Struct.new`, you will use `Micro::Struct.new` to create your Struct classes.

The key difference is: Structs created from `Micro::Struct` will use keyword arguments in their constructors.

```ruby
Person = Struct.new(:name)          # Person
Persona = Micro::Struct.new(:name)  # Persona

Person.ancestors  # [Person, Struct, Enumerable, Object, Kernel, BasicObject]
Persona.ancestors # [Person, Struct, Enumerable, Object, Kernel, BasicObject]

Person.new('Rodrigo')        # #<struct Person name="Rodrigo">
Persona.new(name: 'Rodrigo') # #<struct Person name="Rodrigo">

Person.new  # #<struct Person name=nil>

Persona.new # ArgumentError (missing keyword: :name)
```

[⬆️ &nbsp;Back to Top](#table-of-contents-)

#### `optional:` option

But if you need optional attributes, you can use this to define them.

```ruby
Person = Micro::Struct.new(:name, optional: :age)

Person.new
# ArgumentError (missing keyword: :name)

Person.new(name: 'John')
# #<struct Person name="John", age=nil>
```

Use an array to define multiple optional attributes.

```ruby
Person = Micro::Struct.new(:name, optional: [:age, :nickname])

Person.new
# ArgumentError (missing keyword: :name)

Person.new(name: 'John')
# #<struct Person name="John", age=nil, nickname=nil>
```

[⬆️ &nbsp;Back to Top](#table-of-contents-)

#### `required:` option

It is an alternative way to define required attributes. Use a symbol to define one or an array to define multiple attributes.

```ruby
Person = Micro::Struct.new(
  required: [:first_name, :last_name],
  optional: [:age]
)

Person.new
# ArgumentError (missing keywords: :first_name, :last_name)

Person.new first_name: 'John', last_name: 'Doe'
# #<struct Person first_name="John", last_name="Doe", age=nil>
```

[⬆️ &nbsp;Back to Top](#table-of-contents-)

#### Defining custom methods/behavior

The `Micro::Struct.new` accepts a block as a regular Struct, and you can use it to define some custom behavior/methods.

```ruby
Person = Micro::Struct.new(:first_name, :last_name, optional: :age) do
  def name
    "#{first_name} #{last_name}"
  end
end

person = Person.new(first_name: 'Rodrigo', last_name: 'Serradura')
# #<struct Person first_name="Rodrigo", last_name="Serradura", age=nil>

person.first_name # "Rodrigo"
person.last_name  # "Serradura"
person.name       # "Rodrigo Serradura"
```

[⬆️ &nbsp;Back to Top](#table-of-contents-)

### `Micro::Struct.with`

This method can do two things: first, it can create Struct factories; second, it sets some special behavior to their structs.

These are all of the available features which you can use (pick one, many, or all of them):
- [`:to_ary`](#to_ary)
- [`:to_hash`](#to_hash)
- [`:to_proc`](#to_proc)
- [`:readonly`](#readonly)
- [`:instance_copy`](#instance_copy)
- [`:exposed_features`](#exposed_features)

```ruby
ReadonlyStruct = Micro::Struct.with(:readonly, :instance_copy)

Person = ReadonlyStruct.new(:first_name, :last_name)

Person.new # ArgumentError (missing keywords: :first_name, :last_name)

person = Person.new(first_name: 'Rodrigo', last_name: 'Rodrigues')
# #<struct Person first_name="Rodrigo", last_name="Rodrigues">

person.last_name = ''
# NoMethodError (private method `last_name=' called for #<struct Person ...>)

person[:last_name] = ''
# NoMethodError (private method `[]=' called for #<struct Person ...>)

person.with(last_name: 'Serradura')
# #<struct Person first_name="Rodrigo", last_name="Serradura">
```

[⬆️ &nbsp;Back to Top](#table-of-contents-)

#### `:to_ary`

Defines a `#to_ary` method which will invoke the struct `#to_a` method, so if you overwrite the `#to_a` method you will also affect it.

The `#to_ary` makes Ruby know how to deconstruct an object like an array.

```ruby
Person = Micro::Struct.with(:to_ary).new(:first_name, :last_name)

person = Person.new(first_name: 'Rodrigo', last_name: 'Serradura')

first_name, last_name = person

p first_name # "Rodrigo"
p last_name  # "Serradura"

*first_and_last_name = person

p first_and_last_name # ["Rodrigo", "Serradura"]
```

[⬆️ &nbsp;Back to Top](#table-of-contents-)

#### `:to_hash`

Defines a `#to_hash` method which will invoke the struct `#to_h` method, so if you overwrite the `#to_a` method you will also affect it.

The `#to_hash` makes Ruby know how to deconstruct an object like a hash.

```ruby
Person = Micro::Struct.with(:to_hash).new(:first_name, :last_name)

person = Person.new(first_name: 'Rodrigo', last_name: 'Serradura')

def greet(first_name:, last_name:)
  puts "Hi #{first_name} #{last_name}!"
end

greet(**person)
# Hi Rodrigo Serradura!
```

[⬆️ &nbsp;Back to Top](#table-of-contents-)

#### `:to_proc`

The `#to_proc` tells Ruby how to invoke it as a block replacement (by using `&`).

The lambda returned from the `#to_proc` will require a hash as its argument.

```ruby
Person = Micro::Struct.with(:to_proc).new(:first_name, :last_name)

[
  {first_name: 'John', last_name: 'Doe'},
  {first_name: 'Mary', last_name: 'Doe'}
].map(&Person)
# [
#  #<struct Person::Struct first_name="John", last_name="Doe">,
#  #<struct Person::Struct first_name="Mary", last_name="Doe">
# ]
```

[⬆️ &nbsp;Back to Top](#table-of-contents-)

#### `:readonly`

This feature sets the Struct members' writers as private.

```ruby
Person = Micro::Struct.with(:readonly).new(:first_name, :last_name)

person = Person.new(first_name: 'Rodrigo', last_name: 'Rodrigues')
# #<struct Person first_name="Rodrigo", last_name="Rodrigues">

person.last_name = ''
# NoMethodError (private method `last_name=' called for #<struct Person ...>)

person[:last_name] = ''
# NoMethodError (private method `[]=' called for #<struct Person ...>)
```

[⬆️ &nbsp;Back to Top](#table-of-contents-)

#### `:instance_copy`

Creates the `#with` method, which will instantiate a struct of the same kind and reuse its current state.

```ruby
Person = Micro::Struct.with(:instance_copy).new(:first_name, :last_name)

person = Person.new(first_name: 'Rodrigo', last_name: 'Serradura')
# => #<struct Person::Struct first_name="Rodrigo", last_name="Serradura">

person.first_name = 'John'
# => "John"

person.inspect
# => #<struct Person::Struct first_name="John", last_name="Serradura">

new_person = person.with(last_name: 'Doe')
# => #<struct Person::Struct first_name="John", last_name="Doe">

person === new_person     # => false
person.equal?(new_person) # => false

person.last_name     # => "Serradura"
new_person.last_name # => "Doe"
```

[⬆️ &nbsp;Back to Top](#table-of-contents-)

#### `:exposed_features`

This feature exposes the struct's configured features. Via the methods: `.features` and `.__features__`.

```ruby
Person = Micro::Struct.with(:exposed_features, :readonly, :to_proc).new(:name)

Person.features
# => #<struct Micro::Struct::Features::Exposed
#      names=[:readonly, :to_proc],
#      options={:to_ary=>false, :to_hash=>false, :to_proc=>true, :readonly=>true, :instance_copy=>false}>

Person.__features__.equal?(Person.features) # `.__features__` is an alias of `.features` method

Person.features.names   # => [:readonly, :to_proc]
Person.features.options # => {:to_ary=>false, :to_hash=>false, :to_proc=>true, :readonly=>true, :instance_copy=>false}

Person.features.option?(:to_proc)  # => true
Person.features.option?(:readonly) # => true

Person.features.options?(:to_proc)  # => true
Person.features.options?(:readonly) # => true

Person.features.options?(:to_proc, :readonly) # => true
Person.features.options?(:to_ary, :readonly)  # => false
```

[⬆️ &nbsp;Back to Top](#table-of-contents-)

### `Micro::Struct.instance()` or `Micro::Struct.with(...).instance()`

Creates a struct instance from a given hash. This could be useful to create constants or a singleton value.

```ruby
person1 = Micro::Struct.instance(first_name: 'Rodrigo', last_name: 'Serradura')
# => #<struct  first_name="Rodrigo", last_name="Serradura">

person1.first_name = 'John'

person1.first_name # => "John"
```

You can also use the instance method after defining some struct feature ([`Micro::Struct.with`](#microstructwith)).

```ruby
person2 = Micro::Struct.with(:readonly).instance(first_name: 'Rodrigo', last_name: 'Serradura')
# => #<struct  first_name="Rodrigo", last_name="Serradura">

person2.first_name = 'John'
# NoMethodError (private method `first_name=' called for #<struct first_name="Rodrigo", last_name="Serradura">)
```

And if you need some custom behavior, use a block to define them.

```ruby
person3 = Micro::Struct.instance(first_name: 'Rodrigo', last_name: 'Serradura') do
  def name
    "#{first_name} #{last_name}"
  end
end

person4 = Micro::Struct.with(:readonly).instance(first_name: 'Rodrigo', last_name: 'Serradura') do
  def name
    "#{first_name} #{last_name}"
  end
end

person3.name # => "Rodrigo Serradura"
person4.name # => "Rodrigo Serradura"
```

[⬆️ &nbsp;Back to Top](#table-of-contents-)

### TL;DR

Like in a regular Struct, you can define one or many attributes.
But all of them will be required by default.

```ruby
Micro::Struct.new(:first_name, :last_name, ...)
```

Use the `optional:` arg if you want some optional attributes.

```ruby
Micro::Struct.new(:first_name, :last_name, optional: :gender)

# Using `optional:` to define all attributes are optional.

Micro::Struct.new(optional: [:first_name, :last_name])
```

Use the `required:` arg to define required attributes.

```ruby
Micro::Struct.new(
  required: [:first_name, :last_name],
  optional: [:gender, :age]
)
```

You can also pass a block to define custom methods.

```ruby
Micro::Struct.new(:name) {}
```

Available features (use one, many, or all) to create Structs with a special behavior:

```ruby
Micro::Struct.with(:to_ary)
Micro::Struct.with(:to_ary, :to_hash)
Micro::Struct.with(:to_ary, :to_hash, :to_proc)
Micro::Struct.with(:to_ary, :to_hash, :to_proc, :readonly)
Micro::Struct.with(:to_ary, :to_hash, :to_proc, :readonly, :instance_copy)
Micro::Struct.with(:to_ary, :to_hash, :to_proc, :readonly, :instance_copy, :exposed_features)
```

All of the possible combinations to create a Ruby Struct using `Micro::Struct`:

```ruby
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
```

Any options above can be used by the `.new()` method of the struct creator returned by the `.with()` method.

```ruby
Micro::Struct.with(*features).new(...) {}
```

Use `Micro::Struct.instance()` or `Micro::Struct.with(...).instance()` to create a struct instance from a given hash.

[⬆️ &nbsp;Back to Top](#table-of-contents-)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

[⬆️ &nbsp;Back to Top](#table-of-contents-)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/serradura/u-struct. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/serradura/u-struct/blob/master/CODE_OF_CONDUCT.md).

[⬆️ &nbsp;Back to Top](#table-of-contents-)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[⬆️ &nbsp;Back to Top](#table-of-contents-)

## Code of Conduct

Everyone interacting in the Micro::Struct project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/serradura/u-struct/blob/master/CODE_OF_CONDUCT.md).

[⬆️ &nbsp;Back to Top](#table-of-contents-)
