require_relative 'settings'

module Slack
  def send_to_slack(file_path)
    `curl https://slack.com/api/files.upload -F token='#{Settings.slack_token}' -F file="@#{file_path}", -F channels='#{Settings.slack_channel}'`
  end
end
