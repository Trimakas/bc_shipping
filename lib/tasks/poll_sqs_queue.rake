require 'aws-sdk'
require 'sqs_poll_help'

desc 'Poll the Amazon SQS queue for new messages'
task :poll_sqs_queue => :environment do
File.write("#{Rails.root}/tmp/rake_runtime.txt", DateTime.now.to_s)
  puts "kicking off polling"
  perform_poll
end

  def perform_poll
    client = SqsPollHelp.create_sqs_client
    poller = Aws::SQS::QueuePoller.new(ENV['sqs_url'], {client: client})
    poller.poll(max_number_of_messages:10, idle_timeout: 1) do |messages|
      messages.each do |msg|
        xml_message_from_amazon = Nokogiri::XML(msg["body"])
        SqsPollHelp.what_to_do_with_message(xml_message_from_amazon)
      end
    end
  end