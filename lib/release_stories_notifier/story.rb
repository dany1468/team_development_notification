# frozen_string_literal: true

class ReleaseStoriesNotifier
  class Story
    attr_reader :name, :state, :labels, :url, :pull_request_urls

    class << self
      def next_released(project_id, release_line_story_name)
        stories = client.project(project_id).stories(filter: 'state:started,finished,planned,delivered')

        stories.each_with_object([]) {|s, rc|
          break rc if s.name == release_line_story_name

          rc << s
        }.map {|s|
          pr_urls = s.comments.map {|c| (m = c.text&.match(/(https:\/\/github.com\/.*\/pull\/\d+)/)) && m[1] }.compact
          labels = s.labels&.map(&:name)

          Story.new(s.name, s.url, s.current_state, labels,  pr_urls)
        }
      end

      def client
        @client ||= ReleaseStoriesNotifier.client
      end
    end

    def initialize(name, url, state, labels, pull_request_urls)
      @name = name
      @url = url
      @state = state
      @labels = labels
      @pull_request_urls = pull_request_urls
    end
  end
end
