import UIKit
import RxCocoa
import RxSwift
import RxDataSources


class CostScreenViewModel{
    
    var labelText = BehaviorSubject(value: "\(CostStorageService().fetchSumCurrentDay())")
    var subLabelText = BehaviorSubject(value: "Cегодня")
    var percentArray = BehaviorSubject(value: ["auto": 0.0])
    var categories = BehaviorSubject(value: [SectionModel(model: "", items: [CostCategoryModel]())])
    var categoryChosen = BehaviorSubject(value: 1)
    
    
    func getDayLabelText(){
        subLabelText.on(.next("Сегодня"))
        labelText.on(.next("\(CostStorageService().fetchSumCurrentDay())"))
    }
    
    func getMonthLabelText(){
        subLabelText.on(.next("В этом месяце"))
        labelText.on(.next("\(CostStorageService().fetchSumCurrentMonth())"))
    }
    
    func getYearLabelText(){
        subLabelText.on(.next("В этом году"))
        labelText.on(.next("\(CostStorageService().fetchSumCurrentYear())"))
    }
    
    //Исправить
    func getCircleYear(){
        let dict = GetCostStatistic().getYearPercent()
        var array: [Categories.RawValue: Double] = [:]
        for (category, item) in dict.0{
            if item != 0{
                array[category] = round(item * 100) / 100
            }
        }
        percentArray.on(.next(array))
    }
    
    //Исправить
    func getCircleDay(){
        var dateComponents = DateComponents()
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        let dict = GetCostStatistic().getDayPercent(dateComponents: dateComponents)
        var array: [Categories.RawValue: Double] = [:]
        for (category, item) in dict.0{
            if item != 0{
                array[category] = round(item * 100) / 100
            }
        }
        percentArray.on(.next(array))
        
    }
        
        //Исправить
    func getCircleMonth(){
        var dateComponents = DateComponents()
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        let dict = GetCostStatistic().getMonthPercent(dateComponents: dateComponents)
        var array: [Categories.RawValue: Double] = [:]
        for (category, item) in dict.0{
            if item != 0{
                array[category] = round(item * 100) / 100
            }
            
        }
        
        percentArray.on(.next(array))
    }
    
    func getDayStatistics(){
        var dateComponents = DateComponents()
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        let dict = GetCostStatistic().getDayPercent(dateComponents: dateComponents)
        var array: [CostCategoryModel] = []
        for (category, value) in dict.0{
            let percent = Int(round(value * 100) / 100 * 100)
            if value != 0{
                array.append(CostCategoryModel(costsSum: dict.1[category]!, percents: percent, category: Categories(rawValue: String(category))!, color: CategoryCostsDesignElements().getCategoryColors()[category]!))
            }
        }
        
        array = array.sorted { model1, model2 in
            model1.percents > model2.percents
        }
        
        
        categories.on(.next([SectionModel(model: "Категории Расходов", items: array)]))
        
    }
    
    func getMonthStatistics(){
        var dateComponents = DateComponents()
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        let dict = GetCostStatistic().getMonthPercent(dateComponents: dateComponents)
        var array: [CostCategoryModel] = []
        for (category, value) in dict.0{
            let percent = Int(round(value * 100) / 100 * 100)
            if value != 0{
                array.append(CostCategoryModel(costsSum: dict.1[category]!, percents: percent, category: Categories(rawValue: String(category))!, color: CategoryCostsDesignElements().getCategoryColors()[category]!))
            }
        }
        
        array = array.sorted(by: { model1, model2 in
            model1.percents > model2.percents
        })
        
        categories.on(.next([SectionModel(model: "Категории Расходов", items: array)]))
    }
    
    func getYearStatistics(){
        let dict = GetCostStatistic().getYearPercent()
        var array: [CostCategoryModel] = []
        var persents = 0
        for (category, value) in dict.0{
            let percent = Int(round(value * 100) / 100 * 100)
            if value != 0{
                array.append(CostCategoryModel(costsSum: dict.1[category]!, percents: percent, category: Categories(rawValue: String(category))!, color: CategoryCostsDesignElements().getCategoryColors()[category]!))
            }
        }
        
        array = array.sorted(by: { model1, model2 in
            model1.percents > model2.percents
        })
        
        categories.on(.next([SectionModel(model: "Категории Расходов", items: array)]))
        
    }
}
