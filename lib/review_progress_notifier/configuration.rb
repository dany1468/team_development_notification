class Configuration
  def github_token
    @github_token ||= ENV['GITHUB_TOKEN']
  end

  def notify_channel
    @notify_channel ||= ENV['NOTIFY_CHANNEL']
  end

  def ignore_title_regexp
    @ignore_title_regexp ||= ENV['IGNORE_TITLE_REGEXP']
  end

  def ignore_user_names
    @ignore_user_names ||= ENV['IGNORE_USER_NAMES'].to_s.split(',')
  end
end
