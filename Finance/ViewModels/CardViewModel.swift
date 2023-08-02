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
        var array: [CostCategoryModel] = []
        
        for (category, value) in dict{
            if value != 0{
                array.append(CostCategoryModel(costsSum: 100, percents: Int(round(value * 100) / 100 * 100), category: Categories(rawValue: String(category))!, color: .blue))
            }
        }
        array = array.sorted { model1, model2 in
            model1.percents > model2.percents
        }
        
        categories.on(.next([SectionModel(model: "", items: array)]))
        
    }
    
    func getMonthStatistics(){
        let array: [CostCategoryModel] = [
            CostCategoryModel(costsSum: 4736, percents: 40, category: .auto, color: .cyan),
            CostCategoryModel(costsSum: 64783, percents: 30, category: .houseRent, color: .darkGray),
            CostCategoryModel(costsSum: 4343, percents: 32, category: .householdExpenses, color: .darkGray),
            CostCategoryModel(costsSum: 3232, percents: 21, category: .health, color: .green),
            CostCategoryModel(costsSum: 43, percents: 1, category: .transport, color: .orange)
        ]
        categories.on(.next([SectionModel(model: "", items: array)]))
    }
    
    func getYearStatistics(){
        
    }
    
    func fetchData(){
        
        let array: [CostCategoryModel] = [
            CostCategoryModel(costsSum: 1200, percents: 40, category: .auto, color: .blue),
            CostCategoryModel(costsSum: 1000, percents: 20, category: .health, color: .brown),
            CostCategoryModel(costsSum: 300, percents: 30, category: .houseRent, color: .red)
        ]
        
        categories.on(.next([SectionModel(model: "", items: array)]))
        
    }
}
