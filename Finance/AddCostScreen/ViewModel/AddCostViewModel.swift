import Foundation
import RxCocoa
import RxSwift
import RxDataSources
import RealmSwift
class AddCostViewModel{
    
    var goals = BehaviorSubject(value: [SectionModel(model: "", items: [GoalObject]())])
    
    var goalsShow = BehaviorSubject(value: true)
    
    var categoryShow = BehaviorSubject(value: true)
    
    var selectedItem = BehaviorSubject(value: ["":""])
    
    var typeOfSelectedItem = BehaviorSubject(value: "")
    
    var isItemSelected = BehaviorSubject(value: false)
    
    var datesForSelection = BehaviorSubject(value: [Date]())
    
    var dateSelected = BehaviorSubject(value: Date())
    
    var isDateSelected = BehaviorSubject(value: false)
    
    var sum = BehaviorSubject(value: 0)
    
    var isButtonAble = BehaviorSubject(value: false)
    
    var cost = BehaviorSubject(value: CostRealm(costId: UUID().uuidString, date: Date(), sumCost: 0, label: "", category: "food"))
    
    func fetchDates(){//Исправить 
        
        var array: [Date] = []
        
        var dateComponents = DateComponents()
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
                
        
        array.append(Calendar.current.date(from: dateComponents)!)
        
        if dateComponents.day! - 1 < 1{
            dateComponents.month! -= 1
            dateComponents.day = 30//Исправить
            
        } else {
            dateComponents.day! -= 1
        }
        
        array.insert(Calendar.current.date(from: dateComponents)!, at: 0)
        
        dateComponents.day! -= 1
        
        array.insert(Calendar.current.date(from: dateComponents)!, at: 0)
        
        dateComponents.day! += 3
        
        array.append(Calendar.current.date(from: dateComponents)!)
        
        datesForSelection.on(.next(array))
        
    }
    
    func fetchGoalObjects(){
        
        let goalsService = GoalsService()
        let models = goalsService.getAllGoalModels()
        if models == []{
            goals.on(.next([]))
        } else {
            goals.on(.next([SectionModel(model: "", items: goalsService.getAllGoalModels())]))
        }
    }
    
    func updateGoalObject(picture: String, sum: Int, goalObject: GoalObject){
        
        let goalStorage = GoalsService()
        let newGoalObject = GoalObject(costId: goalObject.costId, goalSum: goalObject.goalSum, currentSum: goalObject.currentSum, picture: goalObject.picture)
        newGoalObject.currentSum += sum
        try! goalStorage.saveNewModel(object: newGoalObject)
        
    }
    
    func buttonStatus(){
        let sum = try! sum.value()
        let isItemSelected = try! isItemSelected.value()
        let isdateSelected = try! isDateSelected.value()
        
        if sum != 0 && isItemSelected && isdateSelected{
            isButtonAble.on(.next(true))
        } else {
            isButtonAble.on(.next(false))
        }
    }
    
    func newValuesForCost(sumCost: Int, category: String, label: String, date: Date){
        cost.on(.next(CostRealm(costId: UUID().uuidString, date: date, sumCost: sumCost, label: label, category: category)))
    }
    
    func saveRealmCost(){
        let storage = StorageService()
        let cost = try! cost.value()
        try! storage.saveOrUpdateObject(object: cost)
        var dateComponents = DateComponents()
        dateComponents.day = Calendar.current.component(.day, from: cost.date)
        dateComponents.month = Calendar.current.component(.month, from: cost.date)
        dateComponents.year = Calendar.current.component(.year, from: cost.date)
        
        SaveSumObjects.saveSumObjects(dateComponents: dateComponents, category: cost.category, sumCost: cost.sumCost)
    }
    
    func saveRealmGoal(){
        let storage = StorageService()
        let cost = try! cost.value()
        try! storage.saveOrUpdateObject(object: cost)
    }
    
}
