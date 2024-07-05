rails: bundle exec rails s -p 3000 -b 0.0.0.0 -P tmp/pids/rails.pid
react: yarn --cwd ./react start
cable: bundle exec puma -p 28080 cable/config.ru
sidekiq: bundle exec sidekiq -C config/sidekiq.yml
