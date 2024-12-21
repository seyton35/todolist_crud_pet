import Member from "../database/Member.js"

const MemberDB = new Member()

class MemberService {
    loginMember = async (email, password) => {
        try {
            const token = await MemberDB.loginMember(email, password)
            return token
        } catch (error) {
            throw error
        }
    }
    createMember = async (email, name, password) => {
        try {
            await MemberDB.createMember(email, name, password)
        } catch (error) {
            throw error
        }
    }
}

export default MemberService