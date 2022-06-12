# frozen_string_literal: true

require_relative 'app'

if ActiveRecord::Base.connection.migration_context.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

run Sinatra::Application
