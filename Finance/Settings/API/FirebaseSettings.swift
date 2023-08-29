import Firebase

class FirebaseSettings{
    
    static func getUID() -> String?{
        
        guard let currentUser = Auth.auth().currentUser else { return nil }
        
        return currentUser.uid
        
    }
    
}
