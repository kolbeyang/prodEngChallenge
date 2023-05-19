Dotenv.load('token.env')

module Api
    module V1

        class QuestionsController < ApplicationController

            @@MAX_TOKENS = 150
            @@TEMPERATURE = 0.0
            @@MODEL = "text-davinci-003"

            def initialize(*)
                token  = ENV['OPENAI']
                @client = OpenAI::Client.new(access_token: token)
            end

            def ask(questionContent)
                prompt = questionContent
                response = @client.completions(parameters: {
                    model: @@MODEL,
                    prompt: prompt,
                    max_tokens: @@MAX_TOKENS,
                    temperature: @@TEMPERATURE
                })
                puts response
                answer = response['choices'][0]['text']

                # store question and answer
                Question.create(question: questionContent, answer: answer, ask_count: 1)

                return answer
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

                answer = ask(questionContent)

                render json: {question: questionContent, answer: answer}
            end

        end
    end
end