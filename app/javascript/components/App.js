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
        <div className="wrapper">
            <form onSubmit={handleSubmit}>
                <div className="title-label">Ask a question about my book! </div>
                <input className="question-input" type="text" value={questionContent} onChange={handleChange}/>
                <button className="main-button" type="submit">Ask!</button>
            </form>
            <div className="response">AnswerContent {answerContent}</div>
        </div>
    )
}

export default App