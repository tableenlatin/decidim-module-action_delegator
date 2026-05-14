# frozen_string_literal: true

require "decidim/action_delegator/verifications/delegations_authorizer"
require "decidim/action_delegator/verifications/delegations_verifier"
require "decidim/action_delegator/admin"
require "decidim/action_delegator/admin_engine"
require "decidim/action_delegator/engine"

module Decidim
  # This namespace holds the logic of the `ActionDelegator` module
  module ActionDelegator
    # this is the SmsGateway provided by this module
    # Note that it will be ignored if you provide your own SmsGateway in Decidim.sms_gateway_service
    mattr_accessor :sms_gateway_service,
                   default: Decidim::Env.new("AD_SMS_GATEWAY_SERVICE", "Decidim::ActionDelegator::SmsGateway").to_s

    # The default expiration time for the integrated authorization
    # if zero, the authorization won't be registered
    mattr_accessor :authorization_expiration_time,
                   default: (Decidim::Env.new("AD_AUTHORIZATION_EXPIRATION_TIME").presence&.to_i || 3.months)

    # Put this to false if you don't want to allow administrators to invite users not registered
    # in the platform when uploading a census (inviting users without permission can be a GDPR offense).
    mattr_accessor :allow_to_invite_users,
                   default: Decidim::Env.new("AD_ALLOW_TO_INVITE_USERS", true).present?

    # If true, tries to automatically authorize users when they log in with the "Corporate Governance Verifier"
    # Note that this is only possible when the verifier is configured to use only the email (if SMS is required, the user will have to do the standard verification process)
    mattr_accessor :authorize_on_login,
                   default: Decidim::Env.new("AD_AUTHORIZE_ON_LOGIN", true).present?

    # used for comparing phone numbers from a census list and the ones introduced by the user
    # the phone number will be normalized before comparing it so, for instance,
    # if you have a census list with  +34 666 666 666 and the user introduces 0034666666666 or 666666666, they will be considered the same
    # can be empty or null if yo don't want to check different combinations of prefixes
    mattr_accessor :phone_prefixes,
                   default: Decidim::Env.new("AD_PHONE_PREFIXES", "+34,0034,34").to_array

    # The regex for validating phone numbers
    mattr_accessor :phone_regex,
                   default: Decidim::Env.new("AD_PHONE_REGEX", '^\d{6,15}$').to_s # 6 to 15 digits
  end
end

# We register 2 global engines to handle logic unrelated to participatory spaces or components

# User space engine, used mostly in the context of the user profile to let the users
# manage their delegations
Decidim.register_global_engine(
  :decidim_action_delegator, # this is the name of the global method to access engine routes
  Decidim::ActionDelegator::Engine,
  at: "/action_delegator"
)
