# README #

### Veracode API scripts ###

### Set Up ###

* Clone repo to local machine
* Set USERNAME and PASSWORD environment variables to API user credentials for your Veracode account
* Dependencies: json, activesupport, rest-client, and commander gems 
* Add /path/to/project/bin to system path
* To run a scan use `veracodeapi scan [appid] [archivepath]`
* Eg: `/home/apiscripts/bin/veracodeapi scan 12345 code.zip`
* `veracodeapi help` to see commands
* `veracodeapi [command] -h` to see command syntax