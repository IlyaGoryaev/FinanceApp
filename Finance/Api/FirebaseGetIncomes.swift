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
            
            let data = dataSnapshot.value as! [String: Any]
            
            var array: [String: Any] = [:]
            
            for item in data{
                let data = try! JSONSerialization.data(withJSONObject: item.value)
                let income = try! JSONDecoder().decode(IncomeRealmFirebase.self, from: data)
                let incomeRealm = IncomeRealm(incomeId: item.key,
                            date: Date(),
                            sumIncome: income.sumIncome,
                            label: income.label,
                            category: income.category)
                try! IncomeStorageService().saveOrUpdateObject(object: incomeRealm)
                
                var dateComponents = DateComponents()
                dateComponents.timeZone = .current
                dateComponents.day = Calendar.current.component(.day, from: incomeRealm.date)
                dateComponents.month = Calendar.current.component(.month, from: incomeRealm.date)
                dateComponents.year = Calendar.current.component(.year, from: incomeRealm.date)
                
                SaveSumObjectIncomes.saveSumObjectsIncome(dateComponents: dateComponents, category: incomeRealm.category, sumIncome: incomeRealm.sumIncome)
            }
            
            print(array)
            
            //let decoder = try! JSONSerialization.data(withJSONObject: data)
            
            
            //print(String(data: decoder, encoding: .utf8)!)
            
        }
        
    }
    
}
