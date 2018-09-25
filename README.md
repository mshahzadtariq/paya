# Paya
This is Ruby / Rails wrapper for Paya (https://paya.com/) based ACH payments. This is third party wrapper and not developed by Paya team. This is developed by reading Paya documentation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paya'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paya

## Usage

Generate a new initlizer file paya.rb in config/initializers folder with your paya credentials. To get paya credentials, contact with Paya development team at https://paya.com/developers

    require 'paya'
    require 'securerandom'

    Paya.user_name = "YOUR_USERNAME"
    Paya.password = "YOUR_PASSWORD"
    Paya.production = false
    
After that, you can process payment according to your requirements.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/paya/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
