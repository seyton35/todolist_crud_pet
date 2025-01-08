import mysql from "mysql2/promise.js";
import { genSalt, hash } from "bcrypt"
import { v4 as uuid } from 'uuid'
import jwt from 'jsonwebtoken'
import { jwtSecret } from '../credentials/config.js'

const generateAccessToken = (payload) => {
    return jwt.sign(payload, jwtSecret, { expiresIn: '10y', })
}

class Member {
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

    loginMember = async (memberEmail, memberPassword) => {
        try {
            const sql = 'SELECT * FROM users WHERE email = ?;'
            const res = await this.#DB.query(sql, memberEmail)
            const member = res[0][0]
            const salt = member.salt
            const hash2 = await hash(memberPassword, salt)
            const doesHashMatch = hash2 === member.hash
            if (!doesHashMatch) {
                throw {
                    status: 401,
                    message: 'email or password is incorrect'
                }
            }
            const accessToken = generateAccessToken({ id_user: member.id_user })
            return accessToken
        } catch (error) {
            throw {
                status: error?.status || 500,
                message: error?.message || error,
            }
        }
    }

    createMember = async (memberEmail, memberName, memberPassword) => {
        try {
            const sql = 'SELECT * FROM users WHERE email = ?;'
            const res = await this.#DB.query(sql, memberEmail)
            if (res[0][0]) throw {
                status: 409,
                message: `The email "${memberEmail}" is already in use`
            }
            const salt = await genSalt(10)
            const memberHash = await hash(memberPassword, salt)
            const newMember = {
                id_user: uuid(),
                name: memberName,
                email: memberEmail,
                hash: memberHash,
                salt: salt,
            }
            this.#DB.query('INSERT INTO `users` (`id_user`, `email`, `name`, `hash`, `salt`)' +
                `VALUES(
                    '${newMember.id_user}',
                    '${newMember.email}',
                    '${newMember.name}',
                    '${newMember.hash}',
                    '${newMember.salt}'
                );`
            )
        } catch (error) {
            throw {
                status: error?.status || 500,
                message: error?.message || error,
            }
        }

    }
}
export default Member