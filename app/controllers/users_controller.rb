# app/controllers/users_controller.rb
class UsersController < ApplicationController
    before_action :authenticate_user, only: [:profile, :my_posts]

    def create
        author = Author.create(name: user_params[:name]) # Create a new author based on the user's name
        @user = User.new(
          name: user_params[:name],
          email: user_params[:email],
          password: user_params[:password],
          author: author # Associate the user with the author
        )
    
        if @user.save
          token = JWT.encode({ user_id: @user.id }, Rails.application.secrets.secret_key_base, 'HS256')
          render json: { token: token, message: 'Registration successful. Please log in.' }, status: :created
        else
          render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end
  
    def profile
        render json: current_user, status: :ok
    end

    def my_posts
        articles = current_user.articles
        # Add logic to get the stats (number of likes, comments, views) for each article
        # and format the JSON response accordingly
        render json: articles, status: :ok
    end



    private
  
    def user_params
      params.permit(:name, :email, :password, :password_confirmation)
    end
  end
  