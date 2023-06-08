module Api
    module V1
      class PostsTestController < ApplicationController
        before_action :set_post, only: [:show, :update, :destroy]
  
        def index
          posts = PostTest.order(created_at: :desc)
          render json: { status: 'SUCCESS', message: 'Loaded posts', data: posts }
        end
  
        def show
          render json: { status: 'SUCCESS', message: 'Loaded the post', data: @post }
        end
  
        def create
          post = PostTest.new(post_params)
          if PostTest.save
            render json: { status: 'SUCCESS', data: post }
          else
            render json: { status: 'ERROR', data: PostTest.errors }
          end
        end
  
        def destroy
          @PostTest.destroy
          render json: { status: 'SUCCESS', message: 'Deleted the post', data: @post }
        end
  
        def update
          if @PostTest.update(post_params)
            render json: { status: 'SUCCESS', message: 'Updated the post', data: @post }
          else
            render json: { status: 'SUCCESS', message: 'Not updated', data: @PostTest.errors }
          end
        end
  
        private
  
        def set_post
          @post = PostTest.find(params[:id])
        end
  
        def post_params
          params.require(:post).permit(:title)
        end
      end
    end
  end