require 'rubygems'
require 'pdf/reader'
require 'tokenizers'
require 'daru'
require "ruby/openai"
require 'csv'
require 'dotenv'
Dotenv.load('token.env')



DOC_EMBEDDINGS_MODEL = "text-search-curie-doc-001"
PDF_FILENAME = "book.pdf"

def count_tokens(content, tokenizer)
    # Find GPTTokenizer
    encoded = tokenizer.encode(content)
    return encoded.tokens.length()
end

def get_embedding(content, client)
    result = client.embeddings(
        parameters: {
            model: DOC_EMBEDDINGS_MODEL,
            input: content
        }
    )
    return result["data"][0]["embedding"]
end

def pdfMigrate(filename)
    # check to see if the files already exists 
    if File.exist?(filename + ".embeddings.csv") && File.exist?(filename + ".pages.csv") 
        puts "Embeddings and Pages CSV files already exist, no need to generate them again"
        return
    end

    res = []
    i = 1 # page counter
    tokenizer = Tokenizers.from_pretrained("gpt2")
    token  = ENV['OPENAI']
    client = OpenAI::Client.new(access_token: token)

    filenamePdf = filename

    PDF::Reader.open(filenamePdf) do |reader|
        reader.pages.each do |page|
            row = []
            
            content = page.text.split # split by whitespace
            content = content.join(" ") # put it back together in one string

            row << "Page " + i.to_s
            row << content
            row << count_tokens(content, tokenizer)
            puts content

            res << row

            i += 1
        end
        end

    filenamePagesCsv = filename + ".pages.csv"

    # df = Daru::DataFrame.rows(res, opts: {order: [:title, :content, :tokens]})
    # df.write_csv("deleteme.csv")

    CSV.open(filenamePagesCsv, "w") do |csv|
        csv << ["title","content", "tokens"]
        res.each do |row|
            csv << row
        end
    end

    filenameEmbeddingsCsv = filename + ".embeddings.csv"

    CSV.open(filenameEmbeddingsCsv, "w") do |csv|
        csv << ["title"].concat([*0..4095])
        counter = 1
        res.each do |row|
            embedding = get_embedding(row[1], client) # row 1 should be the content column 
            csv << ["Page " + counter.to_s].concat(embedding)
            counter += 1
        end
    end
end

pdfMigrate(PDF_FILENAME)