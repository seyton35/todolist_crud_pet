import express from 'express'
import TodoController from '../../controllers/todosController.js'
import authMiddleware from '../../middleware/authMiddleware.js'

export const router = express.Router()

const todoController = new TodoController()
router.get('/test', (req, res) => {
    res.send({
        message: 'ok'
    })
})

router.post('/create', authMiddleware, todoController.createTodo)

router.get('/', authMiddleware, todoController.getTodos)

router.patch('/', authMiddleware, todoController.updateTodo)

router.delete('/', authMiddleware, todoController.deleteTodo)
