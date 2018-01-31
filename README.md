# Clomp 
[![CircleCI](https://circleci.com/gh/rubyrider/clomp.svg?style=svg)](https://circleci.com/gh/rubyrider/clomp) [![Issues](http://img.shields.io/github/issues/rubyrider/clomp.svg)]( https://github.com/rubyrider/clomp/issues ) [![Gem Version](https://badge.fury.io/rb/clomp.svg)](https://badge.fury.io/rb/clomp) [![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT) [![Maintainability](https://api.codeclimate.com/v1/badges/a7edc252626bdf40d389/maintainability)](https://codeclimate.com/github/rubyrider/clomp/maintainability) [![Chat](https://img.shields.io/badge/gitter.im-rubyrider/clomp-green.svg)]( https://gitter.im/clomp-ruby/Lobby ) [![Code Triagers Badge](https://www.codetriage.com/rubyrider/clomp/badges/users.svg)](https://www.codetriage.com/rubyrider/clomp)

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
class AnotherOperation < Clomp::Operation
  track :track_from_another_operation

  def track_from_another_operation(options)
    options[:hello_from_another_operation] = true
  end
end
    
class SingingOperation < Clomp::Operation
    # Configure your operation for common tracks,
    # configuration can be overridden from individual tracks 
    setup do |config|
      config.fail_fast = true
      config.optional = true
     end
      
    # this block only executes on failure step! 
    # pass options to receive the operation states!   
    add_track :get_lyrics do |options|
      # we call this a failure state based block!
      options[:do_some_thing] = 10
    end
    
    add_track :get_instruments_ready
    
    add_track :start_signing
    
    # We can now share specific step from 
    # outsider operation
    share :track_from_another_operation, from: AnotherOperation # Or 'AnotherOperation'
    
    finally :receive_price #final step, wont execute after this step!
    
    def get_instruments_ready(options, params: , **)
      # do anything!
    end
    
    def get_lyrics(options, params: , **)
      params[:singer_name] = 'James' #mutate
    end
    
    def start_signing(options)
      puts options[:params]
    end
    
    def receive_price(options)
      puts "I am honored for this awesome price!"
    end
end
```

```ruby
@result = SingingOperation[singer_name: 'Bass Baba']
@result.success? # => true
@result.failure? # => false
```

Trace the steps:
```ruby
@result = SingingOperation[singer_name: 'Bass Baba']
@result.executed_tracks
"first_track:track:success --> track_from_another_operation:track:success --> call_something:track:success"

@result.to_s
"Clomp::Result > Successful: first_track:track:success --> track_from_another_operation:track:success --> call_something:track:success"
```

## Configuration
You can set custom step name(s), custom fail, pass flow configuration globally and operation wise!

```ruby
Clomp::Configuration.setup do |config|
# You can set as many step name as you want
config.custom_step_names =+ [:my_own_step_name]
end
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
