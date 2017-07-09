# SafeOperation

Write safer code with SafeOperation.

```ruby
any_operation_may_fail = ->{ User.find(1) }

operation = SafeOperation.either(any_operation_may_fail) do
  # MUST handle the failure here
end

# know if operation succeeded
operation.success?

# get the result of the performed operation
operation.result
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
  ActiveRecordRecordNotFound = Class.new(StandardError)

  def self.find(id)
    (id == 1) ? new : raise(ActiveRecordRecordNotFound)
  end

  def self.find_by(*); end
end

class Guest
end

SafeOperation.either(->{ User.find(1) })
# => raises an SafeOperation::NoFailureHandler error

SafeOperation.either(->{ User.find(1) }) do
  Guest.new
end
# => returns a SafeOperation::Success object with User
# => #<SafeOperation::Success:0x007fbc8d8c5ae0 @success=#<User:0x007fbc8d8c5b08>>

SafeOperation.either(->{ User.find(2) }) do
  Guest.new
end
# => rescue ActiveRecordRecordNotFound, returns a SafeOperation::Failure object with Guest
# #<SafeOperation::Failure:0x007fbc8dbb71e0 @failure=#<Guest:0x007fbc8dbb7208>>

SafeOperation.either(->{ User.find_by(id: 42) }) do
  Guest.new
end
# => returns a SafeOperation::Failure object with Guest
# #<SafeOperation::Failure:0x007fbc8dbb71e0 @failure=#<Guest:0x007fbc8dbb7208>>
```

## Contributing

This project follows the [Moya Contributors Guidelines][moya].
TLDR: means we give out push access easily and often.

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

