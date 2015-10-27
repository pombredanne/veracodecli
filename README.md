# veracodecli

A ruby cli gem for interacting with the veracode API

## Table of contents

- [Installation](#installation)
- [Usage](#usage)
- [How To Contribute](#how-to-contribute)
- [License](#license)
- [Contributors](#contributors)

## Installation

```
gem install veracodecli
```

## Usage

1. Set `VERACODE_USERNAME` and `VERACODE_PASSWORD` environment variables to your API credentials for the veracode API.
2. To run a scan use `veracodecli scan _app\_name_ _archive\_path_

- `veracodecli help` to see commands
- `veracodecli [command] -h` to see command syntax

## How To Contribute
This gem uses [jeweler](https://github.com/technicalpickles/jeweler) for development. Read about relevant commands at that repo.

* Fork the project.
* Start a feature/bugfix branch.
* Use `rake install` in the main directory to install the gem on your system.
* Commit and push until you are happy with your contribution.
* Make a pull request to this repo.

## Roadmap
Ideas for future development.

* Config file: Make this cli scanner/tool agnostic. Should work with rest api services from other tools

## License

[MIT](https://tldrlegal.com/license/mit-license)

## Contributors

* Isaiah Thiessen | [email](mailto:isaiah.thiessen@telus.com)
* Ben Visser | [email](mailto:benjamin.visser@telus.com)
