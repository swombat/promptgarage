# These are not combined because we want to reload all models after the migrations take place.
# && bundle exec rails db:seed
release: bundle exec rails db:migrate 
web: bundle exec puma -t 8:32 -p 3000 -e production
worker: bundle exec sidekiq -t 25
