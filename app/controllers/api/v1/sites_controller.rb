module Api
    module V1
        class Api::V1::SitesController < ApplicationController
            skip_before_action :verify_authenticity_token

            before_action :set_site, only: [:show, :update, :destroy]

            def index
            end

            def show
                render json: { status: 'SUCCESS', message: 'Loaded the site', data: @site }
            end

            def site_queries
                site = Site.find_by_domain(params[:domain])
                if site
                    queries = site.queries.order(created_at: :desc)
                    render json: { status: 'SUCCESS', data: site }
                else
                    render json: { status: 'ERROR', data: site.errors }
                end
            end

            def create
                require "nkf"
                site = Site.find_by_domain(params[:domain])
                if site.blank?
                    add_site = Site.new(site_params)
                    begin
                        if add_site.save
                        render json: { status: 'SUCCESS', data: add_site }
                        else
                        render json: { status: 'ERROR', data: add_site.errors }
                        end
                    rescue => e
                        Rails.logger.error("Transaction failed: #{e.message}")
                        raise ActiveRecord::Rollback
                    end
                end
            end

            def destroy
                @site.destroy
                render json: { status: 'SUCCESS', message: 'Deleted the site', data: @site }
            end

            def update
                if @site.update(site_params)
                render json: { status: 'SUCCESS', message: 'Updated the site', data: @site }
                else
                render json: { status: 'SUCCESS', message: 'Not updated', data: @site.errors }
                end
            end

            private

            def set_site
                @site = Site.find_by_domain(params[:domain])
            end

            def site_params
                params.require(:site).permit(:name,:url)
            end
        end
    end
end
