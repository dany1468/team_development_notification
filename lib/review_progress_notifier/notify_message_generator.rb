class ReviewProgressNotifier
  class NotifyMessageGenerator
    class << self
      def generate(repository, pull_requests)
        {
          text: ":chart_with_upwards_trend: PR status: *#{repository}*",
          attachments: pull_requests.map {|pr| generate_attachment(pr) }
        }
      end

      private

      def generate_attachment(pr)
        attachment_fields = {
          'assigned reviewers' => pr.assigned_reviewers.map(&:user).join(', '),
          'まだレビューしてもらえてないみたい :cry: 余裕ができたらよろしくね。' => pr.assigned_reviewers.reject(&:reviewed?).map(&:user).join(', '),
          'すでに :star: をくれたみんなありがとう :tada:' => pr.approved_users.join(', ')
        }.delete_if {|_, v|
          v.nil? || v.empty?
        }.map {|k, v|
          {title: k, value: v.to_s.gsub("'", '')}
        }

        {
          text: "[<https://github.com/#{pr.repository}/pull/#{pr.number}|#{pr.number}>] #{pr.title} by #{pr.author}",
          color: '#ADD8E6',
          fields: attachment_fields,
          mrkdwn_in: %w(text fields)
        }
      end
    end
  end
end
