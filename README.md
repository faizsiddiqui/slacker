# Slacker

"Slacker" - Get the boring stuff done!

## Installation

```bash
bin/setup
bundle exec rake install
gem install pkg/slacker-<version>.gem
```

or

```bash
gem install slacker
```

## Usage

1. Build a stack [Example](example-stack/README.md)

2. Create the inventory file

```json
[
  {
    "hosts": [
      {
        "address": "<host_or_ip>",
        "user": "<user>",
        "password": "<password>"
      }
    ],
    "stack": "<stack_path>"
  }
]
```

3. Run Slacker

```bash
slacker -i <inventory_file> apply
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/faizsiddiqui/slacker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/faizsiddiqui/slacker/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Slacker project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/faizsiddiqui/slacker/blob/main/CODE_OF_CONDUCT.md).
