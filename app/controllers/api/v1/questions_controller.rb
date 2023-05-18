module Api
    module V1
        class QuestionsController < ApplicationController
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