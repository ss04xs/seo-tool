class QueriesController < ApplicationController
    def index
        @sites = Site.order(created_at: :desc)
        @query_data = Query.order(created_at: :desc)
    end
end
