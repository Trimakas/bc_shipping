envs_path = File.expand_path('~/.envs')
if File.exists?(envs_path)
  set :job_template, "/bin/bash -l -c '. #{envs_path} && :job'"
else
  puts ("\e[0;33;49mWARNING: #{envs_path} is not found. You may have to create it and set your " +
        "environment variables in it for this rake task to work properly.\e[0m")
end

every 10.minutes do
  rake "poll_sqs_queue"
end
every 3.hours do
  rake "check_amazon_order_status"
end