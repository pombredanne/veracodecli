# README #

### Set Up ###

* Clone repo to local machine
* Dependencies: Ruby 2.0+, json, activesupport, rest-client, and commander gems
* Set `VERACODE_USERNAME`, `VERACODE_PASSWORD` and `VERACODE_TEAM` environment variables to API user credentials + Team Name for your Veracode account
* Add /path/to/clone/veracodecli/bin to system path
* To run a scan use `veracodecli scan [app_name] [archivepath]`
* Eg: `/home/apiscripts/bin/veracodecli scan MyApplication MyApplicationCode.zip`
* `veracodecli help` to see commands
* `veracodecli [command] -h` to see command syntax

### Future Goals ###
* This project will be expanded on as needed for my/my team's automation needs
