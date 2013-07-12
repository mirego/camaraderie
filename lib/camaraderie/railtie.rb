require 'camaraderie'
require 'rails'

module Camaraderie
  class Railtie < Rails::Railtie
    initializer 'camaraderie.active_record' do |app|
      ActiveSupport.on_load :active_record, {}, &Camaraderie.inject_into_active_record
    end
  end
end
