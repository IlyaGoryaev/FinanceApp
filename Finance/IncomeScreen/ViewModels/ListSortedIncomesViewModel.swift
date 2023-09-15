import RxSwift
import RxCocoa
import RxDataSources
import UIKit

class ListSortedIncomesViewModel{
    
    var array = BehaviorSubject(value: [SectionModel(model: "", items: [IncomeRealm]())])
    
    func fetchData(category: String, periodId: Period){
        switch periodId{
        case .Day:
            let array = GetListOfIncomesByCategoriesService().getListCategoryByDay(date: Date(), category: category)
            self.array.on(.next([SectionModel(model: "", items: array)]))
            break
        case .Month:
            let array = GetListOfIncomesByCategoriesService().getListCategoryByMonth(date: Date(), category: category)
            self.array.on(.next([SectionModel(model: "", items: array)]))
            break
            
        case .Year:
            let array = GetListOfIncomesByCategoriesService().getListCategoryByYear(date: Date(), category: category)
            self.array.on(.next([SectionModel(model: "", items: array)]))
            break
        }
    }
    
}
