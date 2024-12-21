import express from 'express'
import MemberController from '../../controllers/memberController.js'
import { query, param } from 'express-validator'// TODO make it work (not working yet)
import authMiddleware from '../../middleware/authMiddleware.js'

export const router = express.Router()

const memberController = new MemberController()

router.get('/getUser', authMiddleware, memberController.getUser)

router.post('/login', memberController.loginMember)

router.post('/register', memberController.createMember, [
    param('email', 'invalid email address').isEmail(),
    param('name', 'the name can not be empty').isEmpty(),
    param('password', 'password must be not shortee than 6 symbols').isLength({ max: 20, min: 6 }),
])

