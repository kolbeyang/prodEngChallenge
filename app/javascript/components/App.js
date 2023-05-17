import React, { useState } from 'react'

const App = () => {

    const [questionContent, setQuestionContent] = useState('')

    const handleChange = (event) => {
        setQuestionContent(event.target.value)
    }

    const handleSubmit = (event) => {
        event.preventDefault()
        console.log(questionContent)
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