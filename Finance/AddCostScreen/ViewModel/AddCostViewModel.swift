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
    
    var datesForSelection = BehaviorSubject(value: [""])
    
    var dateSelected = BehaviorSubject(value: Date())
    
    var isDateSelected = BehaviorSubject(value: false)
    
    var sum = BehaviorSubject(value: 0)
    
    var isButtonAble = BehaviorSubject(value: false)
    
    var cost = BehaviorSubject(value: CostRealm(costId: UUID().uuidString, date: Date(), sumCost: 0, label: "", category: "food"))
    
    func fetchDates(){//Исправить 
        
        var array: [String] = []
        
        var dateComponents = DateComponents()
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        
        array.append(DateShare.shared.convertFuncDayWithoutYear(dateComponents: dateComponents))
        
        if dateComponents.day! - 1 < 1{
            dateComponents.month! -= 1
            dateComponents.day = 30//Исправить
            
        } else {
            dateComponents.day! -= 1
        }
        
        array.insert(DateShare.shared.convertFuncDayWithoutYear(dateComponents: dateComponents), at: 0)
        
        dateComponents.day! -= 1
        
        array.insert(DateShare.shared.convertFuncDayWithoutYear(dateComponents: dateComponents), at: 0)
        
        dateComponents.day! += 3
        
        array.append(DateShare.shared.convertFuncDayWithoutYear(dateComponents: dateComponents))
        
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
    
    func isGoalsShow(){
        
        goalsShow.on(.next(true))
    }
    
    func isNotGoalsShow(){
        
        goalsShow.on(.next(false))
    }
    
    func isCategoriesShow(){
        categoryShow.on(.next(true))
    }
    
    func isNotCategoriesShow(){
        categoryShow.on(.next(false))
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
    
    func saveRealm(){
        let storage = StorageService()
        let cost = try! cost.value()
        try! storage.saveOrUpdateObject(object: cost)
        var dateComponents = DateComponents()
        dateComponents.day = Calendar.current.component(.day, from: cost.date)
        dateComponents.month = Calendar.current.component(.month, from: cost.date)
        dateComponents.year = Calendar.current.component(.year, from: cost.date)
        let storageSum = SumCostModelsService()
        
        //Дневаная модель
        let costSumDay = storageSum.getDayObjectForKey(day: dateComponents.day!, month: dateComponents.month!, year: dateComponents.year!)
        if costSumDay == []{
            let sumModelDay = SumCostDayModel(costId: DateShare.shared.convertFuncDay(dateComponents: dateComponents), dayValue: dateComponents.day!, monthValue: dateComponents.month!, yearValue: dateComponents.year!, keyValue: "day")
            sumModelDay.dictOfSumByCategories[cost.category]! += cost.sumCost
            try! storageSum.saveNewModel(object: sumModelDay)
            
        } else {
            let sumModel = SumCostDayModel(costId: DateShare.shared.convertFuncDay(dateComponents: dateComponents), dayValue: dateComponents.day!, monthValue: dateComponents.month!, yearValue: dateComponents.year!, keyValue: "day")
            sumModel.dictOfSumByCategories = costSumDay[0].dictOfSumByCategories
            sumModel.dictOfSumByCategories[cost.category]! += cost.sumCost
            try! storageSum.saveNewModel(object: sumModel)
        }
        //Месячная модель
        let costSumMonth = storageSum.getMonthObjectForKey(month: dateComponents.month!, year: dateComponents.year!)
        if costSumMonth == []{
            let sumModelMonth = SumCostMonthModel(costId: DateShare.shared.convertFuncMonth(dateComponents: dateComponents), yearValue: dateComponents.year!, monthValue: dateComponents.month!, keyValue: "month")
            sumModelMonth.dictOfSumByCategories[cost.category]! += cost.sumCost
            try! storageSum.saveNewModel(object: sumModelMonth)
        } else {
            let sumModelMonth = SumCostMonthModel(costId: DateShare.shared.convertFuncMonth(dateComponents: dateComponents), yearValue: dateComponents.year!, monthValue: dateComponents.month!, keyValue: "month")
            sumModelMonth.dictOfSumByCategories = costSumMonth[0].dictOfSumByCategories
            sumModelMonth.dictOfSumByCategories[cost.category]! += cost.sumCost
            try! storageSum.saveNewModel(object: sumModelMonth)
        }
        //Годовая модель
        let costSumYear = storageSum.getYearObjectForKey(year: dateComponents.year!)
        if costSumYear == []{
            let sumYearModel = SumCostYearModel(costId: String(Calendar.current.component(.year, from: Date())), yearValue: dateComponents.year!, keyValue: "year")
            sumYearModel.dictOfSumByCategories[cost.category]! += cost.sumCost
            try! storageSum.saveNewModel(object: sumYearModel)
        } else {
            let sumYearModel = SumCostYearModel(costId: String(Calendar.current.component(.year, from: Date())), yearValue: dateComponents.year!, keyValue: "year")
            sumYearModel.dictOfSumByCategories = costSumYear[0].dictOfSumByCategories
            sumYearModel.dictOfSumByCategories[cost.category]! += cost.sumCost
            try! storageSum.saveNewModel(object: sumYearModel)
        }
    }
    
}
