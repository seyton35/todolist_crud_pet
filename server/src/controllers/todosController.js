import TodoService from "../services/todosService.js";

const todoService = new TodoService()

class TodoController {
    createTodo = async (req, res) => {
        try {
            const { query: { id_todo, task, status, description, deadline, created_at } } = req
            const { user } = req
            if (!task) return res.status(400).send({
                status: 'Failed',
                message: 'Parameters "task" can not be empty'
            })
            const todo = { id_todo, task, description, deadline, created_at }
            if (status == 'true') todo.status = 1
            else todo.status = 0
            const createdTodo = await todoService.createTodo(
                user.id_user,
                todo
            )
            res.send({
                status: 'Ok',
                data: createdTodo
            })
        } catch (error) {
            console.log(error);
            res.status(error?.status || 500).send({
                status: 'Failed',
                data: {
                    error: error?.message || error
                }
            })
        }
    }

    getTodos = async (req, res) => {
        try {
            const { user } = req
            const { query: { page, limit } } = req
            const pageInt = parseInt(page)
            const limitInt = parseInt(limit)
            const { todos, totalPages } = await todoService.getTodos(user.id_user, pageInt, limitInt)
            res.send({
                status: 'Ok',
                todo_list: todos,
                total_pages: totalPages,
            })
        } catch (error) {
            res.status(error?.status || 500).send({
                status: 'Failed',
                data: {
                    error: error?.message || error
                }
            })
        }
    }

    updateTodo = async (req, res) => {
        try {
            const { query: { id_todo, task, deadline, description, status } } = req
            if (!id_todo) return res.status(400).send({
                status: 'Failed',
                message: "Parameter 'id_todo' can not be empty"
            })
            if (!task && !deadline && !description && !status) return res.status(400).send({
                status: 'Failed',
                message: 'At least one of parameters: `task`, `status`, `deadline`, `description` must be not empty'
            })
            let data = {}
            if (task) data.task = task
            if (status) data.status = status == 'true'
            if (deadline !== undefined) {
                if (deadline) data.deadline = deadline
                else data.deadline = null
            }
            if (description !== undefined)
                if (description) data.description = description
                else data.description = null
            const todo = await todoService.updateTodo(id_todo, data)
            res.send({
                status: 'Ok',
                data: todo
            })
        } catch (error) {
            console.log(error);
            res.status(error?.status || 500).send({
                status: 'Failed',
                data: {
                    error: error?.message || error
                }
            })
        }
    }

    deleteTodo = async (req, res) => {
        try {
            const { query: { id_todo } } = req
            await todoService.deleteTodo(id_todo)
            res.send({
                status: 'Ok',
                message: `the row with 'id_todo' = '${id_todo}' was deleted`
            })

        } catch (error) {
            res.status(error?.status || 500).send({
                status: 'Failed',
                data: {
                    error: error?.message || error
                }
            })
        }
    }
}

export default TodoController