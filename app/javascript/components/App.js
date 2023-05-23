import React, { useState } from 'react'
import axios from 'axios'
import { Button, Space, Form, Input, Typography } from 'antd'
const {Title} = Typography

// const layout = {
//     labelCol: { span: 8 },
//     wrapperCol: { span: 16 },
//   };
  

const App = () => {

    const [questionContent, setQuestionContent] = useState('What is the main idea?')
    const [answerContent, setAnswerContent] = useState('')

    const handleChange = (event) => {
        setQuestionContent(event.target.value)
    }

    const handleSubmit = (event) => {
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
        <Space className="wrapper">
            <Title level={2} className="main-title">Ask my book!</Title>
            <Form
                layout="vertical"
                name="nest-messages"
                onFinish={handleSubmit}
                // style={{ width: '100%' }}
                // validateMessages={validateMessages}
            >
                <Form.Item className="question">
                    <Input rows={4} value={questionContent} onChange={handleChange} style={{width:'100%'}} className="question-input"/>
                </Form.Item>
                <Button type="primary" htmlType="submit" className="main-button">Ask!</Button>
            </Form>
            {answerContent !== "" && <Space className="answer-container">
                <Title level={4} className="answer-label">Answer</Title>
                <Title level={5} className="answer-content">{answerContent}</Title>
            </Space>}
        </Space>
    )
}

export default App