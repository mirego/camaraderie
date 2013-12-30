$:.unshift File.expand_path('../lib', __FILE__)

require 'rspec'
require 'sqlite3'

require 'camaraderie'

# Require our macros and extensions
Dir[File.expand_path('../../spec/support/macros/*.rb', __FILE__)].map(&method(:require))

RSpec.configure do |config|
  # Include our macros
  config.include DatabaseMacros
  config.include ModelMacros

  config.before(:each) do
    # Create the SQLite database
    setup_database

    # Run our migration
    run_default_migration

    # Reset Camaraderie.configuration
    Camaraderie.instance_variable_set(:@configuration, nil)

    # Prepare our models array
    @spawned_models = []
  end

  config.after(:each) do
    # Make sure we remove our test database file
    cleanup_database

    # Remove our models
    @spawned_models.each { |model| Object.instance_eval { remove_const model.name.to_sym } }
  end
end
