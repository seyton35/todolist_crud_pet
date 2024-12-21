import MemberService from "../services/membersService.js";
// import { validationResult } from "express-validator";

const memberService = new MemberService()

class MemberController {
    getUser = (req, res) => {
        res.send({ status: 'Ok', message: 'success' })
    }

    loginMember = async (req, res) => {
        const { query: { password, email } } = req
        if (!email || !password) {
            return res.status(400).send({
                status: 'Failed',
                message: 'incorrect login or password',
            })
        }
        try {
            const token = await memberService.loginMember(email, password,)
            res.send({
                status: 'Ok',
                data: token
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

    createMember = async (req, res) => {
        try {
            // const errors = validationResult(req)
            // if (!errors.isEmpty()) return res.status(400).send({
            //     status: 'Failed',
            //     message: errors
            // })
            const { query: { password, email, name, } } = req
            if (!email || !password || !name) return res.status(400).send({
                status: 'Failed',
                message: 'Parameters "email", "password", "name", can not be empty'
            })
            await memberService.createMember(email, name, password)
            res.send({ status: 'Ok', message: 'Account created' })
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

export default MemberController