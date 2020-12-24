class ApplicationController < ActionController::Base

    def encode_token(payload)
        # generate encrypted token for a user
        JWT.encode(payload, 'secret')
    end

    def auth_header
        # returns a string of 'Bearer token'
        request.headers['authorization']
    end

    def decoded_token
        # decode token if it exists in the headers
        if auth_header
            # receive the auth_header, remove 'Bearer ' from the string
            token = auth_header.split(' ')[1]
            begin
                # decode the token
                JWT.decode(token, 'secret')
            rescue JWT::DecodeError
                # catch and handle error
                nil
            end
        end
    end

    def current_user
        # checks for a decoded_token, returns the current user
        if decoded_token
            user_id = decoded_token[0]['user_id']
            current_user = User.find(user_id)
        end
    end

    def logged_in?
        # is current user?
        !!current_user
    end

    def authorized
        # checks logged in status, if fails render JSON
        # use to short-circuit controller actions that require login status
        render json: {error: "Please log in"}, status: :unauthorized unless logged_in?
    end
end
