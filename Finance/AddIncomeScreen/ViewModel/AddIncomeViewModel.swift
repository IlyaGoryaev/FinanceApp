import Foundation
import RxCocoa
import RxSwift
import RxDataSources
import RealmSwift

class AddIncomeViewModel{
    var isItemSelected = BehaviorSubject(value: false)
    
    var datesForSelection = BehaviorSubject(value: [Date]())
    
    var dateSelected = BehaviorSubject(value: Date())
    
    var selectedItem = BehaviorSubject(value: ["":""])
    
    var typeOfSelectedItem = BehaviorSubject(value: "")
    
    var isDateSelected = BehaviorSubject(value: false)
    
    var sum = BehaviorSubject(value: 0)
    
    var isButtonAble = BehaviorSubject(value: false)
    
    var income = BehaviorSubject(value: IncomeRealm(incomeId: UUID().uuidString, date: Date(), sumIncome: 0, label: "", category: "food"))
    
    func fetchDates(){
        //MARK: Добавление дат
        var array: [Date] = []
        let now = Date()
        array.append(now)
        array.append(now + (60 * 60 * 24))
        array.insert(now - (60 * 60 * 24), at: 0)
        array.insert(now - (60 * 60 * 24 * 2), at: 0)
        
        datesForSelection.on(.next(array))
        
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
    
    func newValuesForIncome(sumCost: Int, category: String, label: String, date: Date){
        income.on(.next(IncomeRealm(incomeId: UUID().uuidString, date: date, sumIncome: sumCost, label: label, category: category)))
    }
    
    func saveRealmIncome(){
        let storage = IncomeStorageService()
        let income = try! income.value()
        try! storage.saveOrUpdateObject(object: income)
        
        var dateComponents = DateComponents()
        dateComponents.timeZone = .current
        dateComponents.day = Calendar.current.component(.day, from: income.date)
        dateComponents.month = Calendar.current.component(.month, from: income.date)
        dateComponents.year = Calendar.current.component(.year, from: income.date)
        
        SaveSumObjectIncomes.saveSumObjectsIncome(dateComponents: dateComponents, category: income.category, sumIncome: income.sumIncome)
        
    }
}
