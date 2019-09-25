every 10.minutes do
  rake "poll_sqs_queue"
end
every 3.hours do
  rake "check_amazon_order_status"
end