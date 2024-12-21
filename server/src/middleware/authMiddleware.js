import jwt from 'jsonwebtoken'
import { jwtSecret } from '../credentials/config.js'

const authMiddleware = (req, res, next) => {
    if (req.method === 'OPTIONS') {
        next()
    }
    try {
        const token = req.headers.authorization.split(' ')[1]
        if (!token) return res.status(401).send({
            status: 'Failded',
            message: 'The user is not authorized'
        })
        const decodedData = jwt.verify(token, jwtSecret)
        req.user = decodedData
        next()
    } catch (error) {
        res.status(401).send({
            status: 'Failded',
            message: 'The user is not authorized'
        })
    }
}

export default authMiddleware