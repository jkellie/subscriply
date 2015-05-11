class Api::V1::BaseController < ActionController::Base
  include TokenAuthentication
  include SubdomainHelpers

end