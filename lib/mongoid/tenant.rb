require 'mongoid'
require 'mongoid/tenancy'

require 'mongoid/tenant/railtie' if defined?(Rails)

module Mongoid
  #
  # The tenant
  #
  module Tenant
    extend ActiveSupport::Concern

    included do
      store_in database: lambda {
        current_tenant_key = Thread.current[:tenancy] || raise('No tenancy set!')
        default_db_name = Mongoid.default_client.database.name
        "#{default_db_name}_#{current_tenant_key}"
      }

      def tenancy
        Thread.current[:tenancy]
      end
    end
  end # Tenant
end # Mongoid
