# veracodecli

A ruby cli gem for interacting with the veracode API

## Table of contents

- [Installation](#installation)
- [Usage](#usage)
- [Roadmap](#roadmap)
- [License](#license)
- [Contributors](#contributors)

## Installation

```
gem install veracodecli
```

## Usage

1. set appropriate configs in `/etc/veracodecli.yml`. The only two that are _required_ are `veracode_username` and `veracode_password` that are your API credentials for veracode
2. To run a scan use `veracodecli scan` --app_name _app\_name_ --repo _repo\_url_

- `veracodecli help` to see commands
- `veracodecli [command] -h` to see command syntax

## Roadmap
Ideas for future development.

* Config file: Make this cli scanner/tool agnostic. Should work with rest api services from other tools

## License

[MIT](https://tldrlegal.com/license/mit-license)

## Contributors

* Isaiah Thiessen | [email](mailto:isaiah.thiessen@telus.com)
* Ben Visser | [email](mailto:benjamin.visser@telus.com)
