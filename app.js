const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => {
    res.send('Hello World!')
})

app.get('/getcode', (req, res) => {
    res.send('Hello! This is /getcode .')
})

app.get('/plus/:a/:b', (req, res) => {
    let a = parseInt(req.params.a)
    let b = parseInt(req.params.b)
    res.send(`${a} + ${b} = ${a+b}`)
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})