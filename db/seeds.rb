# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


questions = Question.create([
    {
        question: 'Test Question?',
        answer: 'Test Answer!',
        ask_count: 1
    },
    {
        question: 'Does this work yet?',
        answer: 'I hope so!',
        ask_count: 1
    }
])