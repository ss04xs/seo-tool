class ApplicationController < ActionController::Base
    before_action :basic
    def basic
        authenticate_or_request_with_http_basic do |name, password|
          name == "test0515" && password == "0515"
        end
    end
end
