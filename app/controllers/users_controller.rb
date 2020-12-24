class UsersController < ApplicationController

    def create
        route_not_complete
        # # SIGN-UP USER
        # user = User.new(user_params)
        # if user.save
        #     token = encode_token({ user_id: user.id })
        #     render json: { user: user, token: token }
        # else
        #     render json: user.errors
        # end
    end

    def login
        route_not_complete
        # # byebug
        # user = User.find_by(username: params[:username])
        # # short circuit to avoid error on username-not-found
        # if user && user.authenticate(params[:password])
        #     token = encode_token({ user_id: user.id })
        #     render json: { user: user, token: token }
        # elsif user
        #     render json: {:error => 'incorrect password'}
        # else
        #     render json: {:error => 'username not found'}
        # end
    end


    private

    def route_not_complete
        render json: { message: 'route not complete' }
    end

    def user_params
        params.permit(:username, :password)
    end

end
