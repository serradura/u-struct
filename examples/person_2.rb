# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'u-struct', path: '..'
end

Person = Micro::Struct.with(:readonly, :instance_copy).new(
  required: [:first_name, :last_name],
  optional: [:age]
) do
  def name
    "#{first_name} #{last_name}"
  end
end

person = Person.new(first_name: 'Rodrigo', last_name: 'Serradura')

puts format('first_name: %p', person.first_name)
puts format('last_name: %p', person.last_name)
puts format('name: %p', person.name)
puts format('age: %p', person.age)
puts

rand_age = rand(18..100)

new_person = person.with(age: rand_age)

puts new_person.equal?(person)

puts format('age: %p', person.age)
puts format('age: %p', new_person.age)

person.age = rand_age
