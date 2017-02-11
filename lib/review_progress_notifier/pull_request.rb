class ReviewProgressNotifier
  class PullRequest
    attr_reader :repository, :number, :title, :author

    class << self
      def all(repository, ignore_title_regexp:, ignore_user_names:)
        client.pulls(repository).map {|p|
          PullRequest.new(repository, p[:number], p[:title], p[:user][:login])
        }.reject {|p|
          /#{ignore_title_regexp}/ === p.title ||
            ignore_user_names.include?(p.author)
        }
      end

      def client
        @client ||= ReviewProgressNotifier.client
      end
    end

    def initialize(repository, number, title, author)
      @repository = repository
      @number = number
      @title = title
      @author = author
    end

    def assigned_reviewers
      @assigned_reviewer ||=
        begin
          client.send(:get, "#{Octokit::Repository.path repository}/pulls/#{number}/requested_reviewers", headers: {accept: 'application/vnd.github.black-cat-preview+json'}).map {|c|
            AssignedReviewer.new(c[:login], comments)
          }
        end
    end

    def approved_users
      @approved_users ||= comments.select {|c| /\u{2B50}/ === c.body }.map {|c| c.user }
    end

    private

    def comments
      @comments ||= client.issue_comments(repository, number).map {|c| Comment.new(c[:user][:login], c[:body]) }
    end

    def client
      self.class.client
    end

    class AssignedReviewer
      attr_reader :user

      def initialize(user, comments)
        @user = user
        @reviewed = comments.map(&:user).include?(user)
      end

      def reviewed?
        @reviewed
      end
    end

    class Comment
      attr_reader :user, :body

      def initialize(user, body)
        @user = user
        @body = body
      end
    end
  end
end
