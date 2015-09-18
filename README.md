# README #

### Set Up ###

* Clone repo to local machine
* Set `VERACODE_USERNAME` and `VERACODE_PASSWORD` environment variables to API user credentials for your Veracode account
* Dependencies: json, activesupport, rest-client, and commander gems 
* Add /path/to/clone/veracodecli/bin to system path
* To run a scan use `veracodecli scan [app_name] [archivepath]`
* Eg: `/home/apiscripts/bin/veracodecli scan 12345 code.zip`
* `veracodecli help` to see commands
* `veracodecli [command] -h` to see command syntax

### Future Goals ###
* This project will be expanded on as needed for my own automation needs
