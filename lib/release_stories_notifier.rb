require 'tracker_api'

require_relative 'release_stories_notifier/configuration'
require_relative 'release_stories_notifier/story'

class ReleaseStoriesNotifier
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def client
      @client ||= TrackerApi::Client.new(token: configuration.pivotal_tracker_token)
    end
  end

  def notify_remaining_stories
    stories = Story.next_released(self.class.configuration.project_id, self.class.configuration.release_line_story_name)

    stories.reject! {|s| %w(started finished).include?(s.state) }

    if stories.any?
      # TODO generate notifying message
    end
  end
end
