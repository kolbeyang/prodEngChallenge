import React, { useState } from 'react'
import axios from 'axios'

const App = () => {

    const [questionContent, setQuestionContent] = useState('What is the book about?')
    const [answerContent, setAnswerContent] = useState(' ')

    const handleChange = (event) => {
        setQuestionContent(event.target.value)
    }

    const handleSubmit = (event) => {
        event.preventDefault()
        console.log(questionContent)
        axios.get('/api/v1/questions', {
            params: {question: questionContent}
        }).then( (response) => {
            console.log(response.data)
            setAnswerContent(response.data.answer)
        }).catch( (error) => {
            console.error(error)
        })
    }

    return (
        <>
        <div>This is the App component</div>
            <form onSubmit={handleSubmit}>
                <label>Ask a question about my book!
                    <input type="text" value={questionContent} onChange={handleChange}/>
                </label>
                <button type="submit">Ask!</button>
            </form>
            <p>AnswerContent {answerContent}</p>
        </>
    )
}

export default App