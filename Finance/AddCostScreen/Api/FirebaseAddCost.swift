import Firebase

class FirebaseAddCost{
    
    static func addCost(cost: CostRealm){
        
        let ref = Database.database(url: "https://finance-3fe1b-default-rtdb.europe-west1.firebasedatabase.app").reference()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        ref.child("Costs").child(currentUser.uid).child(cost.costId).setValue(["dayValue": cost.dayValue,
                                                        "monthValue": cost.monthValue,
                                                        "yearValue": cost.yearValue,
                                                        "sumCost": cost.sumCost,
                                                        "label": cost.label,
                                                        "date": cost.date.description,
                                                        "category": cost.category] as [String : Any])
    }
    
}

