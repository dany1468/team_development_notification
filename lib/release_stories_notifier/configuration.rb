class ReleaseStoriesNotifier
  class Configuration
    def pivotal_tracker_token
      @pivotal_tracker_token ||= ENV['PIVOTAL_TRACKER_TOKEN']
    end

    def project_id
      @project_id ||= ENV['PIVOTAL_PROJECT_ID']
    end

    def release_line_story_name
      @release_line_story_name ||= ENV['RELEASE_LINE_STORY_NAME']
    end
  end
end
