import React, { useState } from 'react'
import axios from 'axios'

const App = () => {

    const [questionContent, setQuestionContent] = useState('What is the book about?')

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
                <p>Question Content {questionContent}</p>
                <button type="submit">Ask!</button>
            </form>
        </>
    )
}

export default App