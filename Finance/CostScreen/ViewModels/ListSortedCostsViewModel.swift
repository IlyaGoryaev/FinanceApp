import RxSwift
import RxCocoa
import RxDataSources
import UIKit

class ListSortedCostsViewModel{
    
    var array = BehaviorSubject(value: [SectionModel(model: "", items: [CostRealm]())])
    
    func fetchData(category: String, periodId: Period){
        
        switch periodId{
        case .Day:
            let array = GetListOfCostsByCategoriesService().getListCategoryByDay(date: Date(), category: category)
            self.array.on(.next([SectionModel(model: "", items: array)]))
            break
        case .Month:
            let array = GetListOfCostsByCategoriesService().getListCategoryByMonth(date: Date(), category: category)
            self.array.on(.next([SectionModel(model: "", items: array)]))
            break
        case .Year:
            let array = GetListOfCostsByCategoriesService().getListCategoryByYear(date: Date(), category: category)
            self.array.on(.next([SectionModel(model: "", items: array)]))
            break
        }
    }
    
}
