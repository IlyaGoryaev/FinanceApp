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
    
}
