import mysql from "mysql2/promise.js";

class Todo {
    #DB
    constructor() {
        this.#init()
    }

    async #init() {
        console.log('DB INIT')
        this.#DB = await mysql.createConnection({
            host: "MySQL-8.0",
            user: "root",
            database: "todos",
            password: ""
        })
    }

    createTodo = async (userId, todo) => {
        try {
            let sql = 'INSERT INTO `todos` (id_todo, id_user, task, status ,description, deadline, created_at) VALUES (?,?,?,?,?,?,?);'
            await this.#DB.query(sql, [
                todo.id_todo,
                userId,
                todo.task,
                todo.status,
                todo.description || null,
                todo.deadline || null,
                todo.created_at || Date.now(),
            ])
            sql = 'SELECT * FROM `todos` WHERE `id_todo` = ' + `'${todo.id_todo}';`
            const res = await this.#DB.query(sql)
            const createdTodo = res[0][0]
            return createdTodo
        } catch (error) {
            throw {
                status: error?.status || 500,
                message: error?.message || error,
            }
        }
    }

    getTodos = async (userId, page, limit) => {
        try {
            const sql = 'SELECT * FROM todos WHERE id_user = ? ORDER BY created_at ASC LIMIT ? OFFSET ?;'
            const offset = (page - 1) * limit
            let result = await this.#DB.query(sql, [userId, limit, offset])
            const todos = result[0]
            result = await this.#DB.query('SELECT COUNT(*) FROM todos WHERE id_user = ?;', userId)
            const rows = result[0][0]['COUNT(*)']
            const totalPages = Math.ceil(rows / limit)
            return { todos, totalPages }
        } catch (error) {
            console.log(error);
            throw {
                status: error?.status || 500,
                message: error?.message || error,
            }
        }
    }

    updateTodo = async (todoId, data) => {
        try {
            const getTodoByID = 'SELECT * FROM todos WHERE id_todo = "' + todoId + '";'
            let result = await this.#DB.query(getTodoByID)
            const todo = result[0][0]
            if (!todo) throw {
                status: 400,
                message: `todo with id "${todoId}" not found`
            }
            const sql = 'UPDATE todos SET ? WHERE id_todo = "' + todoId + '";'
            await this.#DB.query(sql, data,);
            result = await this.#DB.query(getTodoByID)
            const updatedTodo = result[0][0]
            return updatedTodo
        } catch (error) {
            console.log(error);
            throw {
                status: error?.status || 500,
                message: error?.message || error,
            }
        }
    }

    deleteTodo = async (todoId) => {
        try {
            const request = 'DELETE FROM `todos` WHERE `id_todo` = ' + `'${todoId}';`
            await this.#DB.query(request)
        } catch (error) {
            throw {
                status: error?.status || 500,
                message: error?.message || error,
            }
        }
    }
}

export default Todo
