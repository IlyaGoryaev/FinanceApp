import Foundation
import RxCocoa
import RxSwift
import RxDataSources
import RealmSwift

//class AddCostViewModel{
//    
//    var categories = BehaviorSubject(value: [SectionModel(model: "", items: [AddCategoryModel]())])
//    var date = BehaviorSubject(value: "433")//изменить на дату
//    var cost = BehaviorSubject(value: CostRealm(costId: UUID().uuidString, date: Date(), sumCost: 0, label: "", category: "food"))
//    var enabled = BehaviorSubject(value: false)
//    var isCategorySelected = BehaviorSubject(value: false)
//    var indexOfItemSelected = BehaviorSubject(value: -1)
//    var sum = BehaviorSubject(value: 0)
//    
//    func fetchCategories(){
//        let array: [AddCategoryModel] = [
//            AddCategoryModel(category: .auto, color: .brown, image: UIImage(named: "auto")),
//            AddCategoryModel(category: .food, color: .cyan, image: UIImage(named: "food")),
//            AddCategoryModel(category: .health, color: .green, image: UIImage(named: "health")),
//            AddCategoryModel(category: .houseRent, color: .magenta, image: UIImage(named: "houseRent")),
//            AddCategoryModel(category: .householdExpenses, color: .orange, image: UIImage(named:"householdExpenses")),
//            AddCategoryModel(category: .pets, color: .purple, image: UIImage(named: "pets")),
//            AddCategoryModel(category: .sport, color: .red, image: UIImage(named: "sport")),
//            AddCategoryModel(category: .transport, color: .systemMint, image: UIImage(named: "transport")),
//            AddCategoryModel(category: .workExpenses, color: .gray, image: UIImage(named: "workExpenses"))]
//        categories.on(.next( [SectionModel(model: "Категории", items: array)] ))
//    }
//    
//    func newValuesForCost(sumCost: Int, category: Categories, label: String, date: Date){
//        cost.on(.next(CostRealm(costId: UUID().uuidString, date: date, sumCost: sumCost, label: label, category: category.rawValue)))
//    }
//    
//    
//    //Инкапсулировать
//    func saveRealm(){
//        let storage = StorageService()
//        let cost = try! cost.value()
//        try! storage.saveOrUpdateObject(object: cost)
//        var dateComponents = DateComponents()
//        dateComponents.day = Calendar.current.component(.day, from: cost.date)
//        dateComponents.month = Calendar.current.component(.month, from: cost.date)
//        dateComponents.year = Calendar.current.component(.year, from: cost.date)
//        let storageSum = SumCostModelsService()
//        
//        //Дневаная модель
//        let costSumDay = storageSum.getDayObjectForKey(day: dateComponents.day!, month: dateComponents.month!, year: dateComponents.year!)
//        if costSumDay == []{
//            let sumModelDay = SumCostDayModel(costId: DateShare.shared.convertFuncDay(dateComponents: dateComponents), dayValue: dateComponents.day!, monthValue: dateComponents.month!, yearValue: dateComponents.year!, keyValue: "day")
//            sumModelDay.dictOfSumByCategories[cost.category]! += cost.sumCost
//            try! storageSum.saveNewModel(object: sumModelDay)
//            
//        } else {
//            let sumModel = SumCostDayModel(costId: DateShare.shared.convertFuncDay(dateComponents: dateComponents), dayValue: dateComponents.day!, monthValue: dateComponents.month!, yearValue: dateComponents.year!, keyValue: "day")
//            sumModel.dictOfSumByCategories = costSumDay[0].dictOfSumByCategories
//            sumModel.dictOfSumByCategories[cost.category]! += cost.sumCost
//            try! storageSum.saveNewModel(object: sumModel)
//        }
//        //Месячная модель
//        let costSumMonth = storageSum.getMonthObjectForKey(month: dateComponents.month!, year: dateComponents.year!)
//        if costSumMonth == []{
//            let sumModelMonth = SumCostMonthModel(costId: DateShare.shared.convertFuncMonth(dateComponents: dateComponents), yearValue: dateComponents.year!, monthValue: dateComponents.month!, keyValue: "month")
//            sumModelMonth.dictOfSumByCategories[cost.category]! += cost.sumCost
//            try! storageSum.saveNewModel(object: sumModelMonth)
//        } else {
//            let sumModelMonth = SumCostMonthModel(costId: DateShare.shared.convertFuncMonth(dateComponents: dateComponents), yearValue: dateComponents.year!, monthValue: dateComponents.month!, keyValue: "month")
//            sumModelMonth.dictOfSumByCategories = costSumMonth[0].dictOfSumByCategories
//            sumModelMonth.dictOfSumByCategories[cost.category]! += cost.sumCost
//            try! storageSum.saveNewModel(object: sumModelMonth)
//        }
//        //Годовая модель
//        let costSumYear = storageSum.getYearObjectForKey(year: dateComponents.year!)
//        if costSumYear == []{
//            let sumYearModel = SumCostYearModel(costId: String(Calendar.current.component(.year, from: Date())), yearValue: dateComponents.year!, keyValue: "year")
//            sumYearModel.dictOfSumByCategories[cost.category]! += cost.sumCost
//            try! storageSum.saveNewModel(object: sumYearModel)
//        } else {
//            let sumYearModel = SumCostYearModel(costId: String(Calendar.current.component(.year, from: Date())), yearValue: dateComponents.year!, keyValue: "year")
//            sumYearModel.dictOfSumByCategories = costSumYear[0].dictOfSumByCategories
//            sumYearModel.dictOfSumByCategories[cost.category]! += cost.sumCost
//            try! storageSum.saveNewModel(object: sumYearModel)
//        }
//    }
//    
//    
//    func sumAndCategoryChosen(){
//        enabled.on(.next(true))
//    }
//    
//    func categorySelect(isSelect: Bool){
//        isCategorySelected.on(.next(isSelect))
//    }
//    
//    func itemSelect(index: Int){
//        indexOfItemSelected.on(.next(index))
//    }
//    
//    func getSum(sum: Int){
//        self.sum.on(.next(sum))
//    }
//    
//}
class AddCostViewModel{
    
    var goals = BehaviorSubject(value: [SectionModel(model: "", items: [GoalObject]())])
    
    var goalsShow = BehaviorSubject(value: true)
    
    var categoryShow = BehaviorSubject(value: true)
    
    func fetchGoalObjects(){
        
        let goalsService = GoalsService()
        print(goalsService.getAllGoalModels())
        
        goals.on(.next([SectionModel(model: "", items: goalsService.getAllGoalModels())]))
    
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
    
}
