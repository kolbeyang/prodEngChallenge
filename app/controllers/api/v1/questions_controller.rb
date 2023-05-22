Dotenv.load('token.env')

module Api
    module V1

        class QuestionsController < ApplicationController

            @@MAX_TOKENS = 150
            @@TEMPERATURE = 0.0
            @@MODEL = "text-davinci-003"
            @@EMBEDDINGS_FILENAME = "Decindep.pdf.embeddings.csv"
            @@PAGES_FILENAME = "Decindep.pdf.pages.csv"
            @@QUERY_EMBEDDINGS_MODEL = "text-search-curie-query-001"
            @@DOC_EMBEDDINGS_MODEL = "text-search-curie-doc-001"
            @@SEPARATOR = "\n* "
            @@SEPARATOR_LENGTH = 3
            @@MAX_SECTION_LENGTH = 500

            def initialize(*)
                token  = ENV['OPENAI']
                @client = OpenAI::Client.new(access_token: token)
            end

            def load_embeddings(filename)
                df = Daru::DataFrame.from_csv(filename)
                columns = df.vectors
                max_dim = columns.to_a[-1].to_i
                output = {}
                df.each_row do |row|
                    row_embedding = []
                    for i in 0..(max_dim - 1) do
                        row_embedding << row[i]
                    end
                    output[row["title"]] = row_embedding
                end

                return output
            end

            def get_embedding(question, model)
                result =  @client.embeddings(
                    parameters: {
                        model: model,
                        input: question
                    }
                )
                return result["data"][0]["embedding"]
            end

            def get_doc_embedding(question)
                return get_embedding(question, @@DOC_EMBEDDINGS_MODEL)
            end

            def get_query_embedding(question)
                return get_embedding(question, @@QUERY_EMBEDDINGS_MODEL)
            end

            def vector_similarity(in1, in2)
                sum = 0.0
                x = in1.to_a
                y = in2.to_a
                for i in 0..(x.length - 1)
                    x_value = x[i] || 0
                    y_value = y[i] || 0
                    sum += x_value * y_value
                end
                return sum
            end

            def order_document_sections(question, content_embeddings)
                query_embedding = get_query_embedding(question)
                ordered_by_similarity = content_embeddings.sort_by{ |k, doc_embedding| -vector_similarity(query_embedding, doc_embedding) }
                return ordered_by_similarity
            end

            def construct_prompt(question, content_embeddings, df)
                most_relevant_sections = order_document_sections(question, content_embeddings)

                chosen_sections = []
                chosen_sections_len = 0

                most_relevant_sections.each do |section|
                    section_key = section[0] # section is a pair ["Page n", [embedding vector]]
                    document_section = nil

                    df.each_row do |row|
                        if row["title"] == section_key
                            document_section = row
                            break
                        end
                    end

                    chosen_sections_len += document_section["tokens"] + @@SEPARATOR_LENGTH
                    if chosen_sections_len > @@MAX_SECTION_LENGTH
                        space_left = @@MAX_SECTION_LENGTH - chosen_sections_len - @@SEPARATOR_LENGTH
                        chosen_sections << @@SEPARATOR + document_section["content"][0..(document_section["tokens"] + space_left)]
                        break
                    end

                    chosen_sections << SEPARATOR + document_section["content"]

                end

                header = "Here is some context which may be useful in answering the question\n"

                prompt =  header + chosen_sections.join("") + "\n\nQuestion:\n" + question
                puts prompt
                return prompt
            end

            def ask(questionContent)
                embeddings_file_path = @@EMBEDDINGS_FILENAME
                content_embeddings = load_embeddings(embeddings_file_path)

                df = Daru::DataFrame.from_csv(@@PAGES_FILENAME)

                prompt = construct_prompt(questionContent, content_embeddings, df)
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