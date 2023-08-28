import Firebase

class RegDataValidation{
    
    static func regEmailValidate(email: String) -> Bool{
        email.contains("@") && !email.isEmpty
    }
    
    static func regPasswordValidate(password: String) -> Bool{
        password.count >= 8
    }
    
}
