import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift

class CostModelView{
    
    var costs = BehaviorSubject(value: [SectionModel(model: "", items: [CostRealm]())])
    
    var amountOfDays = BehaviorSubject(value: 3)
        
    func fetchCosts(){
        let storage = StorageService()
        var arraySection: [any SectionModelType] = []
        for date in storage.fetchAllDates().sorted().reversed(){
            var dateComponents = DateComponents()
            dateComponents.day = Calendar.current.component(.day, from: date)
            dateComponents.month = Calendar.current.component(.month, from: date)
            dateComponents.year = Calendar.current.component(.year, from: date)
            arraySection.append(SectionModel(model: DateShare.shared.convertFuncDay(dateComponents: dateComponents), items: storage.fetchByDate(day: Calendar.current.component(.day, from: date), month: Calendar.current.component(.month, from: date), year: Calendar.current.component(.year, from: date)).reversed()))
        }
        costs.on(.next(arraySection as! [SectionModel<String, CostRealm>]))
        print(storage.fetchAllDates())
    }
    
    func addCosts(cost: CostRealm){
        guard var sections = try? costs.value() else { return }
        
        let storage = StorageService()
        try! storage.saveOrUpdateObject(object: cost)

        var currentSectionDate = sections[0]
        currentSectionDate.items.insert(cost, at: 0)
        currentSectionDate.model = "\(DateShare.shared.getDay()).\(DateShare.shared.getMonth())"
        sections[0] = currentSectionDate
        self.costs.on(.next(sections))
    }
    
    func fetchDayCosts(){
        let storage = StorageService()
        var array = storage.fetchByDate(day: Calendar.current.component(.day, from: Date()), month: Calendar.current.component(.month, from: Date()), year: Calendar.current.component(.year, from: Date()))
        var dateComponents = DateComponents()
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        array = array.sorted { cost1, cost2 in
            cost1.date > cost2.date
        }
        costs.on(.next([SectionModel(model: DateShare.shared.convertFuncDay(dateComponents: dateComponents), items: array)]))
    }
    
    func fetchMonthCosts(){
        let storage = StorageService()
        var dateComponents = DateComponents()
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        var array = storage.fetchObjectsByMonth(month: dateComponents.month!, year: dateComponents.year!)
        costs.on(.next([SectionModel(model: DateShare().convertFuncMonth(dateComponents: dateComponents), items: array)]))
        
        
    }
    func fetchWeekCosts(){
        let storage = StorageService()
        var array: [any SectionModelType] = []
        var dateComponents = DateComponents()
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        let daysWeek = Calendar.current.component(.weekday, from: Date()) == 1 ? 7 : Calendar.current.component(.weekday, from: Date()) - 1
        for i in 0...daysWeek - 1{
            array.append(SectionModel(model: DateShare().convertFuncDay(dateComponents: dateComponents), items: storage.fetchByDate(day: dateComponents.day!, month: dateComponents.month!, year: dateComponents.year!)))
            dateComponents.day! -= 1
        }
        costs.on(.next(array as! [SectionModel<String, CostRealm>]))
        
    }
    
}
