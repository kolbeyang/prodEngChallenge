module Api
    module V1
        class QuestionsController < ApplicationController
            def index
                render json: {response: "Success"}
            end

        end
    end
end