# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

if Rails.env.production?
    puts "Running in production"
  elsif Rails.env.test?
    puts "Running in test"
  else
    puts "Running in development"
  end