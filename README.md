# README

ruby version 3.2.2
rails version 6.1.7.3

## Setup

### OpenAI API Key
Provide your OpenAI API Key as an environment variable.
If running locally, include a file called token.env with the following line

```
OPENAI = 'your api key'
```

### Chose a PDF

Right now book.pdf is a pdf of the Declaration of Independence.

If you would like this app to answer questions about another pdf, replace book.pdf with another file named book.pdf. Delete book.pdf.embeddings.csv and book.pdf.pages.csv. Next the app initializes it will regenerate those two files based on the new pdf.

### Start the app

```
yarn install
bundle install
rails db:migrate
rails s
```

