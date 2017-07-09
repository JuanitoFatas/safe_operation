# SafeOperation

Write safer code with SafeOperation.

```ruby
any_operation_may_fail = ->{ ... }

SafeOperation.either(any_operation_may_fail) do
  # must handles failure here
end
```

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

```ruby
class User
  def self.find(id)
    new if id == 1
  end

  def id
    1
  end

  def name
    "User"
  end
end

class Guest
  def id
    nil
  end

  def name
    "Guest"
  end
end

SafeOperation.either(->{ User.find(1) }) do
  Guest.new
end

SafeOperation.either(->{ User.find(2) }) do
  Guest.new
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JuanitoFatas/safe_operation. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SafeOperation project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/JuanitoFatas/safe_operation/blob/master/CODE_OF_CONDUCT.md).
