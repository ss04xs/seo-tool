class QueryController < ApplicationController
    def index
        query_data = Query.order(created_at: :desc)
        render json: { status: 'SUCCESS', message: 'Loaded posts', data: query_data }
    end
end
