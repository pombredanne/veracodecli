Support for this gem will soon be dropped in favour of https://github.com/isand3r/apidragon

# veracodecli

[![Code Climate](https://codeclimate.com/github/isand3r/veracodecli/badges/gpa.svg)](https://codeclimate.com/github/isand3r/veracodecli)

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
2. To run a scan use `veracodecli scan` _app\_name_ --repo _repo\_url_

- `veracodecli help` to see commands
- `veracodecli [command] -h` to see command syntax

(append `--trace` to the end to see a stack trace if you are encountering errors.)

## License

[MIT](https://tldrlegal.com/license/mit-license)

## Contributors

* Isaiah Thiessen | [email](mailto:isaiah.thiessen@telus.com)
* Ben Visser | [email](mailto:benjamin.visser@telus.com)
