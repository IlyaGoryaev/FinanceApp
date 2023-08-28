import Firebase
import Foundation

class FirebaseGetIncomes{
    
    static func getIncomes(){
        
        guard let currentUser = Auth.auth().currentUser else { return }
        print(currentUser.uid)
        
        let ref = Database.database(url: "https://finance-3fe1b-default-rtdb.europe-west1.firebasedatabase.app").reference().child("Incomes").child(currentUser.uid).getData { error, dataSnapshot in
            if let error = error{
                print(error)
                return
            }
            
            guard let dataSnapshot = dataSnapshot else { return }
            
            let decoder = try! JSONSerialization.data(withJSONObject: dataSnapshot.value as Any)
            
            let jsonDecoder = try! JSONSerialization.data(withJSONObject: decoder)
            
            print(jsonDecoder)
            
            do {
                let jsonDecoder = try JSONDecoder().decode([IncomeRealmFirebase].self, from: decoder)
                print(jsonDecoder)
            } catch let jsonError{
                print(jsonError)
            }
            
            
            
            
        }
        
    }
    
}
