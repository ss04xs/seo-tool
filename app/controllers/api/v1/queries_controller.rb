module Api
    module V1
        class Api::V1::QueriesController < ApplicationController
            skip_before_action :verify_authenticity_token

            before_action :set_query, only: [:show, :update, :destroy]

            def index
                site = Site.find_by_domain(params[:site_domain])
              
                if site
                  rank_data = fetch_rank_data(site, params[:search_type])
                  render json: { status: 'SUCCESS', rows: rank_data }
                else
                  render json: { status: 'ERROR', rows: site.errors }
                end
            end

            def all_queries
                 # サイトごとにクエリデータとそのランクデータを取得
                sites_with_queries = Site.includes(queries: :ranks).map do |site|
                    {
                    site_name: site.name,
                    site_url: site.domain,
                    queries: site.queries.map do |query|
                        {
                        id: query.id,
                        keyword: query.keyword,
                        url: query.url,
                        created_at: query.created_at.strftime('%Y-%m-%d %H:%M:%S'),
                        ranks: query.ranks.map do |rank|
                            {
                            id: rank.id,
                            gsp_rank: rank.gsp_rank,
                            map_rank: rank.map_rank,
                            detection_url: rank.detection_url,
                            created_at: rank.created_at.strftime('%Y-%m-%d %H:%M:%S')
                            }
                        end
                        }
                    end    
                    }
                end
                # JSON形式で返す
                render json: { status: 'SUCCESS', data: sites_with_queries }
            end

            def queries_by_domain
                domain = params[:domain]
                site = Site.includes(queries: :ranks).find_by(domain: domain)
        
                if site
                  site_rank_queries = fetch_rank_data(site, "0")
                  site_map_rank_queries = fetch_rank_data(site, "1")
        
                  render json: { status: 'SUCCESSA', data: [site_rank_queries,site_map_rank_queries] }
                else
                  render json: { status: 'ERROR', message: 'Site not found' }, status: 404
                end
            end

            def map_index
                site = Site.find_by_domain(params[:site_domain])
                if site
                    queries = site.queries.order(created_at: :desc)
                    rank_data = []
                    queries.each do |query|
                        ranks = query.ranks.map do |rank|
                            {
                            map_rank: rank.map_rank,
                            detection_url: rank.detection_url,
                            get_date: rank.get_date
                            }
                        end
                        rank_data << { keyword: query.keyword, url: query.url, ranks: ranks }
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
                require "nkf"
                query = Query.new(query_params)
                site_domain = params[:domain]
                site = Site.find_by_domain(site_domain)
                logger.debug(query)
                if site.present?
                    query.site_id = site.id
                end
                logger.debug(query.keyword)
                #全角スペースを半角に変換
                re_keyword = NKF.nkf("-Z1 -w", query.keyword)
                query.keyword = re_keyword
                if query.url.blank?
                    query.url = site_domain
                end
                logger.debug(query.keyword)
                begin
                    logger.debug(query.attributes)
                    logger.debug(site)
                    if query.save && site
                        render json: { status: 'SUCCESS', data: query }
                    else
                        logger.debug(query.errors.full_messages)
                        render json: { status: 'ERROR', data: query.errors }
                    end
                rescue => e
                    Rails.logger.error("Transaction failed: #{e.message}")
                    raise ActiveRecord::Rollback
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
                params.require(:query).permit(:url,:keyword,:zone_type,:search_type)
            end

            def site_params
                params.require(:site).permit(:name,:url)
            end

            def fetch_rank_data(site, search_type)
                queries =
                  case search_type
                  when "0"
                    site.queries.for_search_type_zero.order(created_at: :desc)
                  when "1"
                    site.queries.for_search_type_one.order(created_at: :desc)
                  else
                    []
                  end
              
                queries.map do |query|
                    [query.keyword, query.url, query.ranks]
                end
            end              
        end
    end
end
