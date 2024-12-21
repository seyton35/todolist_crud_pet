import express from 'express'
import bodyParser from 'body-parser'
import { router as v1MemberRouter } from './v1/routes/memberRoutes.js'
import { router as v1TodoRouter } from './v1/routes/todoRoutes.js'

//** documentation */
// const {
//     swaggerDocs: v1SwaggerDocs,
// } = require('./v1/swagger')


const app = express()
const PORT = process.env.PORT || 3000

app.use(bodyParser.json())
app.use('/api/v1/members', v1MemberRouter)
app.use('/api/v1/todos', v1TodoRouter)

app.listen(PORT, () => {
    console.log(`API is listening on port ${PORT}`)
    // v1SwaggerDocs(app, PORT)
})