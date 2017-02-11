require_relative '../lib/review_progress_notifier'

schedule '* * * * *' do
  begin
    ReviewProgressNotifier.new.perform('')
  rescue => e
    Slappy.logger.info e
  end
end
