require 'dotenv'
Dotenv.load('token.env')
load_dotenv('.env')

module Api
    module V1

        MAX_TOKENS = 150
        TEMPERATURE = 0.0
        MODEL = "text-davinci-003"
        token  = ENV['TOKEN']
        client = OpenAI::Client.new(access_token: token)

        class QuestionsController < ApplicationController

            def ask(questionContent)
                prompt = questionContent
                client.completions(model: MODEL, prompt: prompt, max_tokens: MAX_TOKENS, temperature: TEMPERATURE)
            end

            def index
                questionContent = params[:question]
                questions = Question.all
                
                if questionContent[-1] != "?"
                    questionContent += "?"
                end

                # [1,2,3,4,5].select {|num| num.even? }
                previousQuestions = questions.select {|q| q.question == questionContent }
                if not(previousQuestions.empty?)
                    puts "\t*** Question has been asked before, returning cached response"
                    # question has been asked before
                    render json: {question: previousQuestions[0].question, answer: previousQuestions[0].answer}
                    return
                end

                render json: {question: questionContent, answer: "Success, received a new question: " + questionContent}
            end

        end
    end
end