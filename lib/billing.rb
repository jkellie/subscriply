module Billing

  def self.with_lock(organization, &block)
    Mutex.new.synchronize do
      Recurly.subdomain = organization.recurly_subdomain
      Recurly.api_key = organization.recurly_private_key

      block.call
    end
  end

end