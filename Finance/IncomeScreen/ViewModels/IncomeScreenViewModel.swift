import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class IncomeScreenViewModel{
    
    var labelText = BehaviorSubject(value: "\(IncomeStorageService().fetchSumCurrentDay())")
    var subLabelText = BehaviorSubject(value: "Cегодня")
    var percentArray = BehaviorSubject(value: ["auto": 0.0])
    var categories = BehaviorSubject(value: [SectionModel(model: "", items: [IncomeCategoryModel]())])
    var extraValueDay = BehaviorSubject(value: false)
    var extraValueMonth = BehaviorSubject(value: false)
    var extraValueYear = BehaviorSubject(value: false)
    var extraValue = BehaviorSubject(value: false)
    var categoryChosen = BehaviorSubject(value: 1)
    
    
    func getDayLabelText(){
        subLabelText.on(.next("Сегодня"))
        labelText.on(.next("\(IncomeStorageService().fetchSumCurrentDay())"))
    }
    
    func getMonthLabelText(){
        subLabelText.on(.next("В этом месяце"))
        labelText.on(.next("\(IncomeStorageService().fetchSumCurrentMonth())"))
    }
    
    
    func getYearLabelText(){
        subLabelText.on(.next("В этом году"))
        labelText.on(.next("\(IncomeStorageService().fetchSumCurrentYear())"))
    }
    
    //Исправить
    func getCircleYear(){
        let dict = GetIncomeStatistic().getYearPercent()
        var array: [IncomeCategories.RawValue: Double] = [:]
        for (category, item) in dict.0{
            if item != 0{
                array[category] = round(item * 100) / 100
            }
        }
        percentArray.on(.next(array))
    }
    
    func getCircleDay(){
        var dateComponents = DateComponents()
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        let dict = GetIncomeStatistic().getDayPercent(dateComponents: dateComponents)
        var array: [IncomeCategories.RawValue: Double] = [:]
        for (category, item) in dict.0{
            if item != 0{
                array[category] = round(item * 100) / 100
            }
        }
        percentArray.on(.next(array))
        
    }
    
    func getCircleMonth(){
        var dateComponents = DateComponents()
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        let dict = GetIncomeStatistic().getMonthPercent(dateComponents: dateComponents)
        var array: [IncomeCategories.RawValue: Double] = [:]
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
        let dict = GetIncomeStatistic().getDayPercent(dateComponents: dateComponents)
        var percents = 0
        var array: [IncomeCategoryModel] = []
        for (category, value) in dict.0{
            let percent = Int(round(value * 100) / 100 * 100)
            if value != 0{
                if percent > 4{
                    array.append(IncomeCategoryModel(incomeSum: dict.1[category]!, percents: percent, category: IncomeCategories(rawValue: String(category))!, color: CategoryIncomeDesignElements().getCategoryColors()[category]!))
                } else {
                    percents += percent
                }
            }
        }
        
        array = array.sorted { model1, model2 in
            model1.percents > model2.percents
        }
        
        if percents != 0{
            array.append(IncomeCategoryModel(incomeSum: 1000, percents: percents, category: .businessIncome, color: .black))
            extraValueDay.on(.next(true))
        }
        
        categories.on(.next([SectionModel(model: "Категории доходов", items: array)]))
        
    }
    
    func getMonthStatistics(){
        var dateComponents = DateComponents()
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        let dict = GetIncomeStatistic().getMonthPercent(dateComponents: dateComponents)
        var array: [IncomeCategoryModel] = []
        var persents = 0
        for (category, value) in dict.0{
            let percent = Int(round(value * 100) / 100 * 100)
            if value != 0{
                if percent > 4{
                    
                    array.append(IncomeCategoryModel(incomeSum: dict.1[category]!, percents: percent, category: IncomeCategories(rawValue: String(category))!, color: CategoryIncomeDesignElements().getCategoryColors()[category]!))
                } else {
                    persents += percent
                }
            }
        }
        
        array = array.sorted(by: { model1, model2 in
            model1.percents > model2.percents
        })
        
        if persents != 0{
            array.append(IncomeCategoryModel(incomeSum: 1000, percents: persents, category: .businessIncome, color: .black))
            extraValueMonth.on(.next(true))
        }
        
        
        categories.on(.next([SectionModel(model: "Категории доходов", items: array)]))
    }
    
    
    func getYearStatistics(){
        let dict = GetIncomeStatistic().getYearPercent()
        var array: [IncomeCategoryModel] = []
        var persents = 0
        for (category, value) in dict.0{
            let percent = Int(round(value * 100) / 100 * 100)
            if value != 0{
                if percent > 4{
                    print(percent)
                    array.append(IncomeCategoryModel(incomeSum: dict.1[category]!, percents: percent, category: IncomeCategories(rawValue: String(category))!, color: CategoryIncomeDesignElements().getCategoryColors()[category]!))
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
            array.append(IncomeCategoryModel(incomeSum: 1000, percents: persents, category: .businessIncome, color: .black))
            extraValueYear.on(.next(true))
        }
        
        categories.on(.next([SectionModel(model: "Категории доходов", items: array)]))
        
    }
    
}

