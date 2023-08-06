import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class CardViewModel{
    
    var categories = BehaviorSubject(value: [SectionModel(model: "", items: [CostCategoryModel]())])
    
    func getDayStatistics(){
        var dateComponents = DateComponents()
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        let dict = GetStatistic().getDayPercent(dateComponents: dateComponents)
        print(dict)
        var array: [CostCategoryModel] = []
        for (category, value) in dict.0{
            if value != 0{
                array.append(CostCategoryModel(costsSum: dict.1[category]!, percents: Int(round(value * 100) / 100 * 100), category: Categories(rawValue: String(category))!, color: CategoryCostsDesignElements().getCategoryColors()[category]!))
            }
        }
        
        array = array.sorted { model1, model2 in
            model1.percents > model2.percents
        }
        
        categories.on(.next([SectionModel(model: "", items: array)]))
        
    }
    
    func getMonthStatistics(){
        var dateComponents = DateComponents()
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        let dict = GetStatistic().getMonthPercent(dateComponents: dateComponents)
        var array: [CostCategoryModel] = []
        for (category, value) in dict.0{
            if value != 0{
                array.append(CostCategoryModel(costsSum: dict.1[category]!, percents: Int(round(value * 100) / 100 * 100), category: Categories(rawValue: String(category))!, color: CategoryCostsDesignElements().getCategoryColors()[category]!))
            }
        }
        
        array = array.sorted(by: { model1, model2 in
            model1.percents > model2.percents
        })
        
        categories.on(.next([SectionModel(model: "", items: array)]))
    }
    
    func getYearStatistics(){
        let dict = GetStatistic().getYearPercent()
        var array: [CostCategoryModel] = []
        for (category, value) in dict.0{
            if value != 0{
                array.append(CostCategoryModel(costsSum: dict.1[category]!, percents: Int(round(value * 100) / 100 * 100), category: Categories(rawValue: String(category))!, color: CategoryCostsDesignElements().getCategoryColors()[category]!))
            }
        }
        
        array = array.sorted(by: { model1, model2 in
            model1.percents > model2.percents
        })
        
        categories.on(.next([SectionModel(model: "", items: array)]))
        
    }
}
