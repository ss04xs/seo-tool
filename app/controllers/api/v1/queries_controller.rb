module Api
    module V1
        class Api::V1::QueriesController < ApplicationController
            skip_before_action :verify_authenticity_token

            before_action :set_query, only: [:show, :update, :destroy]

            def index
                site = Site.find_by_domain(params[:site_domain])
                if site
                    queries = site.queries.order(created_at: :desc)
                    rank_data = {}
                    queries.each do |query|
                        rank_data[query.keyword] = query.ranks
                    end
                    render json: { status: 'SUCCESS', rows: rank_data }
                else
                    render json: { status: 'ERROR', rows: site.errors }
                end
            end

            def show
                render json: { status: 'SUCCESS', message: 'Loaded the query', data: @query }
            end

            def site_queries
                site = Site.find_by_domain(params[:site_domain])
                if site
                    queries = site.queries.order(created_at: :desc)
                    render json: { status: 'SUCCESS', data: site }
                else
                    render json: { status: 'ERROR', data: site.errors }
                end
            end

            def create
                query = Query.new(query_params)
                if query.save
                render json: { status: 'SUCCESS', data: query }
                else
                render json: { status: 'ERROR', data: query.errors }
                end
            end

            def site_create
                site = Site.new(site_params)
                if site.save
                    render json: { status: 'SUCCESS', data: site }
                else
                    render json: { status: 'ERROR', data: site.errors }
                end
            end

            def destroy
                @query.destroy
                render json: { status: 'SUCCESS', message: 'Deleted the query', data: @query }
            end

            def update
                if @query.update(query_params)
                render json: { status: 'SUCCESS', message: 'Updated the query', data: @query }
                else
                render json: { status: 'SUCCESS', message: 'Not updated', data: @Query.errors }
                end
            end

            private

            def set_query
                @query = Query.find(params[:id])
            end

            def query_params
                params.require(:query).permit(:url,:keyword,:site_id,:zone_type)
            end

            def site_params
                params.require(:site).permit(:name,:url)
            end
        end
    end
end
