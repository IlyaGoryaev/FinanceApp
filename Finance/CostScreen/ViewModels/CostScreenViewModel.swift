import UIKit
import RxCocoa
import RxSwift
import RxDataSources


class CostScreenViewModel{
    
    var labelText = BehaviorSubject(value: "\(StorageService().fetchSumCurrentDay())")
    var subLabelText = BehaviorSubject(value: "Cегодня")
    var percentArray = BehaviorSubject(value: ["auto": 0.0])
    var categories = BehaviorSubject(value: [SectionModel(model: "", items: [CostCategoryModel]())])
    var goals = BehaviorSubject(value: [SectionModel(model: "", items: [GoalObject]())])
    var extraValueDay = BehaviorSubject(value: false)
    var extraValueMonth = BehaviorSubject(value: false)
    var extraValueYear = BehaviorSubject(value: false)
    var extraValue = BehaviorSubject(value: false)
    
    func fetchGoalObjects(){
        let goalsService = GoalsService()
        goals.on(.next([SectionModel(model: "", items: goalsService.getAllGoalModels())]))
    }
    
    func getDayLabelText(){
        subLabelText.on(.next("Сегодня"))
        labelText.on(.next("\(StorageService().fetchSumCurrentDay())"))
    }
    
    func getMonthLabelText(){
        subLabelText.on(.next("В этом месяце"))
        labelText.on(.next("\(StorageService().fetchSumCurrentMonth())"))
    }
    
    func getYearLabelText(){
        subLabelText.on(.next("В этом году"))
        labelText.on(.next("\(StorageService().fetchSumCurrentYear())"))
    }
    
    //Исправить
    func getCircleYear(){
        let dict = GetStatistic().getYearPercent()
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
        let dict = GetStatistic().getDayPercent(dateComponents: dateComponents)
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
        let dict = GetStatistic().getMonthPercent(dateComponents: dateComponents)
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
        let dict = GetStatistic().getDayPercent(dateComponents: dateComponents)
        var percents = 0
        var array: [CostCategoryModel] = []
        for (category, value) in dict.0{
            let percent = Int(round(value * 100) / 100 * 100)
            if value != 0{
                if percent > 4{
                    array.append(CostCategoryModel(costsSum: dict.1[category]!, percents: percent, category: Categories(rawValue: String(category))!, color: CategoryCostsDesignElements().getCategoryColors()[category]!))
                } else {
                    percents += percent
                }
            }
        }
        
        array = array.sorted { model1, model2 in
            model1.percents > model2.percents
        }
        
        if percents != 0{
            array.append(CostCategoryModel(costsSum: 1000, percents: percents, category: .auto, color: .black))
            extraValueDay.on(.next(true))
        }
        
        
        
        categories.on(.next([SectionModel(model: "Категории Расходов", items: array)]))
        
    }
    
    func getMonthStatistics(){
        var dateComponents = DateComponents()
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        let dict = GetStatistic().getMonthPercent(dateComponents: dateComponents)
        var array: [CostCategoryModel] = []
        var persents = 0
        for (category, value) in dict.0{
            let percent = Int(round(value * 100) / 100 * 100)
            if value != 0{
                if percent > 4{
                    
                    array.append(CostCategoryModel(costsSum: dict.1[category]!, percents: percent, category: Categories(rawValue: String(category))!, color: CategoryCostsDesignElements().getCategoryColors()[category]!))
                } else {
                    persents += percent
                }
            }
        }
        
        array = array.sorted(by: { model1, model2 in
            model1.percents > model2.percents
        })
        
        if persents != 0{
            array.append(CostCategoryModel(costsSum: 1000, percents: persents, category: .auto, color: .black))
            extraValueMonth.on(.next(true))
        }
        
        
        categories.on(.next([SectionModel(model: "Категории Расходов", items: array)]))
    }
    
    func getYearStatistics(){
        let dict = GetStatistic().getYearPercent()
        var array: [CostCategoryModel] = []
        var persents = 0
        for (category, value) in dict.0{
            let percent = Int(round(value * 100) / 100 * 100)
            if value != 0{
                if percent > 4{
                    print(percent)
                    array.append(CostCategoryModel(costsSum: dict.1[category]!, percents: percent, category: Categories(rawValue: String(category))!, color: CategoryCostsDesignElements().getCategoryColors()[category]!))
                } else {
                    print(percent)
                    persents += percent
                }
            }
        }
        
        array = array.sorted(by: { model1, model2 in
            model1.percents > model2.percents
        })
        
        if persents != 0{
            array.append(CostCategoryModel(costsSum: 1000, percents: persents, category: .auto, color: .black))
            extraValueYear.on(.next(true))
        }
        
        categories.on(.next([SectionModel(model: "Категории Расходов", items: array)]))
        
    }
}
