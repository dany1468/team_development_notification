require 'octokit'

require_relative 'review_progress_notifier/configuration'
require_relative 'review_progress_notifier/pull_request'
require_relative 'review_progress_notifier/notify_message_generator'

class ReviewProgressNotifier
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def client
      @client ||= Octokit::Client.new(access_token: configuration.github_token)
    end
  end

  def perform(repository)
    open_pulls = PullRequest.all(repository, ignore_title_regexp: self.class.configuration.ignore_title_regexp, ignore_user_names: self.class.configuration.ignore_user_names)

    if open_pulls.any?
      message = NotifyMessageGenerator.generate(repository, open_pulls.reverse)

      Slack.chat_postMessage(channel: self.class.configuration.notify_channel, text: message[:text], attachments: message[:attachments].to_json)
    end
  end
end
