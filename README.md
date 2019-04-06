# SafeOperation

[![Gem Version](https://badge.fury.io/rb/safe_operation.svg)](https://rubygems.org/gems/safe_operation)
[![Build Status](https://travis-ci.org/JuanitoFatas/safe_operation.svg?branch=master)](https://travis-ci.org/JuanitoFatas/safe_operation)

Write safer code with SafeOperation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "safe_operation"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install safe_operation

## Usage

No monkey patch.

```ruby
class RecordNotFound < StandardError; end
class User def self.find(id); new; end; end;
class Guest; end
class Admin; def initialize(user); end; end
class SuperAdmin; def initialize(admin); end; end

operation = SafeOperation.run do
  User.find(1)
end

# Know if operation succeeded
operation.success?

# Get the value of the performed operation
operation.value

# Common patterns, reloaded
SafeOperation.run { User.find(1) }.value_or(Guest.new)

# Handling exceptions
SafeOperation.run { raise(RecordNotFound) }.value_or_else do |exception|
  if exception.is_a?(RecordNotFound)
    Guest.new
  else
    # logging, re-raise, etc.
  end
end

# Apply on first operation
operation = SafeOperation.
  run { User.find(1) }.
  and_then { |user| Admin.new(user) }

operation.value # #<Admin ...>

# Chainable
operation = SafeOperation.
  run { User.find(1) }.
  and_then { |user| Admin.new(user) }.
  and_then { |admin| SuperAdmin.new(admin) }

operation.value # #<SuperAdmin ...>

# Add or_else to handle failed operation
operation = SafeOperation.
  run { raise(RecordNotFound) }.
  and_then { |user| Admin.new(user) }.
  or_else { Guest.new }

operation.success? # => false
operation.value # => #<Guest ...>
```

See test suite for more examples.

## Contributing

This project follows the [Moya Contributors Guidelines][moya].
TLDR: means we give out commit access easily and often.

[moya]: https://github.com/Moya/contributors

Bug reports and pull requests are welcome on GitHub at https://github.com/JuanitoFatas/safe_operation.
This project is intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SafeOperation project’s codebases, issue trackers is expected to follow
the [code of conduct](https://github.com/JuanitoFatas/safe_operation/blob/master/CODE_OF_CONDUCT.md).
