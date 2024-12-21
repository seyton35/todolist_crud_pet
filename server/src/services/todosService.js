import Todo from "../database/Todo.js"
import { v4 as uuid } from 'uuid'

const TodoDB = new Todo()

class TodoService {
    createTodo = async (userId, todo) => {
        try {
            if (todo.id_todo == null) {
                todo.id_todo = uuid()
            }
            const createdTodo = await TodoDB.createTodo(userId, todo)
            return createdTodo
        } catch (error) {
            throw error
        }
    }

    getTodos = async (userId, page, limit) => {
        try {
            return await TodoDB.getTodos(userId, page, limit)
        } catch (error) {
            throw error
        }
    }

    updateTodo = async (todoId, data) => {
        try {
            const todo = await TodoDB.updateTodo(todoId, data)
            return todo
        } catch (error) {
            throw error
        }
    }

    deleteTodo = async (todoId) => {
        try {
            await TodoDB.deleteTodo(todoId)
        } catch (error) {
            throw error
        }
    }

}

export default TodoService