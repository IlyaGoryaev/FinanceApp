import RxSwift
import RxCocoa
import RxDataSources
import UIKit

class ListSortedCostsViewModel{
    
    var array = BehaviorSubject(value: [SectionModel(model: "", items: [CostRealm]())])
    
    func fetchData(category: String, periodId: Int){
        switch periodId{
        case 1:
            let array = GetListOfCostsByCategoriesService().getListCategoryByDay(date: Date(), category: category)
            self.array.on(.next([SectionModel(model: "", items: array)]))
            break
        case 2:
            let array = GetListOfCostsByCategoriesService().getListCategoryByMonth(date: Date(), category: category)
            self.array.on(.next([SectionModel(model: "", items: array)]))
            break
        case 3:
            let array = GetListOfCostsByCategoriesService().getListCategoryByYear(date: Date(), category: category)
            self.array.on(.next([SectionModel(model: "", items: array)]))
            break
        default:
            break
            
        }
    }
    
}
