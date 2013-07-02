require 'macedoine'
require 'rails'

module Macedoine
  class Railtie < Rails::Railtie
    initializer 'macedoine.active_record' do |app|
      ActiveSupport.on_load :active_record, {}, &Macedoine.inject_into_active_record
    end
  end
end
