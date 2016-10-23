require 'mongoid'
require 'mongoid/tenancy'

require 'mongoid/tenant/railtie' if defined?(Rails)

module Mongoid
  #
  # The tenant
  #
  module Tenant
    extend ActiveSupport::Concern

    module Errors
      class TenantNotSetError < StandardError; end
    end

    included do
      store_in database: lambda {
        current_tenant_key = Thread.current[:tenancy] || raise(Mongoid::Tenant::Errors::TenantNotSetError.new)
        default_db_name = Mongoid.default_client.database.name
        "#{default_db_name}_#{current_tenant_key}"
      }

      def tenancy
        Thread.current[:tenancy]
      end
    end
  end # Tenant
end # Mongoid
