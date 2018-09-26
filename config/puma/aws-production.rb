app_path = File.expand_path('../../../', __FILE__)
environment "production"
pidfile "/tmp/puma.pid"
state_path "/tmp/puma.state"

# Feel free to experiment with this, 0/16 is a good starting point.
threads_count = Integer(ENV['MAX_THREADS'] || 8)
threads threads_count, 40

# Go with at least 1 per CPU core, a higher amount will usually help for fast
# responses such as reading from a cache.
workers Integer(ENV['WEB_CONCURRENCY'] || 2)

# Preload the application before starting the workers.
preload_app!

# Listen on a tcp port or unix socket.
#bind "{{ puma_bind }}"
bind "tcp://0.0.0.0:9494"
#bind "ssl://0.0.0.0:{{ bytestand_app_port }}?key={{ puma_ssl_key }}&cert={{ puma_ssl_cert }}"

#daemonize true

restart_command 'bin/puma'

on_worker_boot do
# Don't bother having the master process hang onto older connections.
 defined?(ActiveRecord::Base) and
   ActiveRecord::Base.connection.disconnect!

 defined?(ActiveRecord::Base) and
   ActiveRecord::Base.establish_connection

end
