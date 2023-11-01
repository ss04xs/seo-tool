class QueriesController < ApplicationController
    def index
        @sites = Site.order(created_at: :desc)
        @query_data = Query.order(created_at: :desc)
    end

    def add
    end

    def query_create
        headers = request.headers["HTTP_HOST"] 
        require 'net/http'
        require 'uri'
        require "nkf"
        keyword = params[:keyword]
        re_keyword = NKF.nkf("-Z1 -w", keyword)
        key_url = params[:key_url]
        delete_flag = params[:delete]
        domain_name = params[:domain_name]
        if delete_flag && delete_flag == true
        #削除プログラム
        end
        if headers == "localhost:3000"
            uri = URI.parse('http://localhost:3000/api/v1/queries')
        else
            uri = URI.parse('https://seo-kaiseki.com/api/v1/queries')
        end
        req = Net::HTTP::Post.new(uri.path)
        req.basic_auth("test0515", "0515")
        req.set_form_data({'query[keyword]'=>"#{re_keyword}", 'query[url]'=>"#{key_url}", 'domain'=>"#{domain_name}"})
        res = Net::HTTP.new(uri.host, uri.port).start {|http| http.request(req) }
        logger.debug res.body
        case res
        when Net::HTTPSuccess, Net::HTTPRedirection
        # OK
        message = JSON.parse(res.body)["status"]
        else
        message = JSON.parse(res.body)
        end
        redirect_to queries_path
    end
end
