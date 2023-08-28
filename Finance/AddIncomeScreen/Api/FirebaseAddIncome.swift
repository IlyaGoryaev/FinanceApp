import Foundation
import Firebase

final class FirebaseAddIncome{
    
    static func addIncome(income: IncomeRealm){
        
        let ref = Database.database(url: "https://finance-3fe1b-default-rtdb.europe-west1.firebasedatabase.app").reference()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        ref.child("Incomes").child(currentUser.uid).child(income.incomeId).setValue(["dayValue": income.dayValue,
                                                        "monthValue": income.monthValue,
                                                        "yearValue": income.yearValue,
                                                        "sumIncome": income.sumIncome,
                                                        "label": income.label,
                                                        "date": income.date.description,
                                                        "category": income.category] as [String : Any])
        
    }
    
}
//@Persisted(primaryKey: true) var incomeId: String
//@Persisted var dayValue: Int
//@Persisted var monthValue: Int
//@Persisted var yearValue: Int
//@Persisted var sumIncome: Int
//@Persisted var label: String
//@Persisted var date: Date
//@Persisted var category: IncomeCategories.RawValue
