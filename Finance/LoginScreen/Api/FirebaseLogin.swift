import Firebase

class FirebaseLogin{
    
    static func registerUser(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error{
                print(error)
                return
            }
            
            guard let authResult = authResult else { return }
            
            print(authResult.user.email)
        }
    }
    
    static func loginUserWithEmail(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error{
                print(error)
                return
            }
            
            guard let authResult = authResult else { return }
            
            print(authResult.user.email)
        }
    }
    
    static func isUserLogIn() -> Bool{
        let user = Auth.auth().currentUser
        
        if user == nil {
            return false
        } else {
            return true
        }
    }
    
}
