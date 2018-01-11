# Clomp [![CircleCI](https://circleci.com/gh/rubyrider/clomp.svg?style=svg)](https://circleci.com/gh/rubyrider/clomp)

**Clomp gem provides a smooth, lightweight, productive and reusable way to build an operation using Railway oriented programing paradigm.**
Clomp will give you an easy interface to complete your service operation. You can use it with any framework 
or plain ruby object. 
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'Clomp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install Clomp

## Usage
Build any service with the track! Add as many tracks as you want.
tracks will be loaded sequentially. You can control success and failure state of any 
specific step.


Consider the following class:
```ruby
class SingingOperation < Clomp::Operation
    # this block only executes on failure step! 
    # pass options to receive the operation states!   
    add_track :get_lyrics do |options|
      # we call this a failure state based block!
      options[:do_some_thing] = 10
    end
    
    add_track :get_instruments_ready
    
    add_track :start_signing
    
    finally :receive_price #final step, wont execute after this step!
    
    def get_instruments_ready(options, mutable_data: , **)
      # do anything!
    end
    
    def get_lyrics(options, mutable_data: , **)
      mutable_data[:singer_name] = 'James' #mutate
    end
    
    def start_signing(options)
      puts options[:mutable_options]
    end
    
    def receive_price(options)
      puts "I am honored for this awesome price!"
    end
end
```

```ruby
@result = SingingOperation[singer_name: 'Base Baba']
@result.success? # => true
@result.failure? # => false
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rubyrider/clomp. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TheRailway project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rubyrider/clomp/blob/master/CODE_OF_CONDUCT.md).
