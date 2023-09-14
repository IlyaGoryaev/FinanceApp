import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import DGCharts


class CostScreenViewModel{
    
    let view: CostScreenProtocol?
    
    var percentArray = BehaviorSubject(value: ["auto": 0.0])
    var categories = BehaviorSubject(value: [SectionModel(model: "", items: [CostCategoryModel]())])
    var categoryChosen = BehaviorSubject(value: 1)
    var isCategoryEmpty = BehaviorSubject(value: true)
    
    let costDescription = BehaviorSubject(value: CostScreenModel())
    
    init(viewController: CostScreenProtocol){
        self.view = viewController
    }
    
    
//    func getDayStatistics(){
//        var dateComponents = DateComponents()
//        dateComponents.day = Calendar.current.component(.day, from: Date())
//        dateComponents.month = Calendar.current.component(.month, from: Date())
//        dateComponents.year = Calendar.current.component(.year, from: Date())
//        let dict = GetCostStatistic().getDayPercent(dateComponents: dateComponents)
//        var array: [CostCategoryModel] = []
//        for (category, value) in dict.0{
//            let percent = Int(round(value * 100) / 100 * 100)
//            if value != 0{
//                array.append(CostCategoryModel(costsSum: dict.1[category]!, percents: percent, category: Categories(rawValue: String(category))!, color: CategoryCostsDesignElements().getCategoryColors()[category]!))
//            }
//        }
//

//
//    }
    
    func setUpDayScreen(){
        var array: [CostCategoryModel] = []
        var dateComponents = DateComponents()
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        let dict = GetCostStatistic().getDayPercent(dateComponents: dateComponents)
        
        let sumCost = String(CostStorageService().fetchSumCurrentDay())
        let centerText = NSAttributedString(
            string: sumCost,
            attributes: [
                .font : UIFont.systemFont(ofSize: 20, weight: .bold),
                .foregroundColor : UIColor(named: "BoldLabelsColor")!
            ])
        
        view!.pieChart.centerAttributedText = centerText
        
        var entries = [PieChartDataEntry]()
        var colors = [UIColor]()
        for (category, value) in dict.0{
            let percent = Int(round(value * 100) / 100 * 100)
            if value != 0{
                array.append(CostCategoryModel(costsSum: dict.1[category]!, percents: percent, category: Categories(rawValue: String(category))!, color: CategoryCostsDesignElements().getCategoryColors()[category]!))
                entries.append(PieChartDataEntry(value: value * 100))
                colors.append(CategoryCostsDesignElements().getCategoryColors()[category]!)
            }
        }
        
        let set = PieChartDataSet(entries: entries, label: String())
        let data = PieChartData(dataSet: set)
        set.colors = colors
        view?.pieChart.data = data
        array = array.sorted { model1, model2 in
            model1.percents > model2.percents
        }

        if array.isEmpty {
            isCategoryEmpty.on(.next(true))
        } else {
            isCategoryEmpty.on(.next(false))
        }

        categories.on(.next([SectionModel(model: "Категории Расходов", items: array)]))
    }
    
    func setUpMonthScreen(){
        var dateComponents = DateComponents()
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        let dict = GetCostStatistic().getMonthPercent(dateComponents: dateComponents)
        let costSum = String(CostStorageService().fetchSumCurrentMonth())
        let centerText = NSAttributedString(
            string: costSum,
            attributes: [
                .font : UIFont.systemFont(ofSize: 20, weight: .bold),
                .foregroundColor : UIColor(named: "BoldLabelsColor")!
            ])
        
        view?.pieChart.centerAttributedText = centerText
        var entries = [PieChartDataEntry]()
        var colors = [UIColor]()
        for (category, value) in dict.0{
            if value != 0{
                entries.append(PieChartDataEntry(value: value * 100))
                colors.append(CategoryCostsDesignElements().getCategoryColors()[category]!)
            }
        }
        
        let set = PieChartDataSet(entries: entries, label: String())
        let data = PieChartData(dataSet: set)
        set.colors = colors
        view?.pieChart.data = data
    }
    
    
    
//    func getMonthStatistics(){
//        var dateComponents = DateComponents()
//        dateComponents.month = Calendar.current.component(.month, from: Date())
//        dateComponents.year = Calendar.current.component(.year, from: Date())
//        let dict = GetCostStatistic().getMonthPercent(dateComponents: dateComponents)
//        var array: [CostCategoryModel] = []
//        for (category, value) in dict.0{
//            let percent = Int(round(value * 100) / 100 * 100)
//            if value != 0{
//                array.append(CostCategoryModel(costsSum: dict.1[category]!, percents: percent, category: Categories(rawValue: String(category))!, color: CategoryCostsDesignElements().getCategoryColors()[category]!))
//            }
//        }
//
//        array = array.sorted(by: { model1, model2 in
//            model1.percents > model2.percents
//        })
//
//        if array.isEmpty {
//            isCategoryEmpty.on(.next(true))
//        } else {
//            isCategoryEmpty.on(.next(false))
//        }
//
//        categories.on(.next([SectionModel(model: "Категории Расходов", items: array)]))
//    }
    
    
    func setUpYearScreen(){
        let dict = GetCostStatistic().getYearPercent()
        let costSum = String(CostStorageService().fetchSumCurrentYear())
        
        let centerText = NSAttributedString(
            string: costSum,
            attributes: [
                .font : UIFont.systemFont(ofSize: 20, weight: .bold),
                .foregroundColor : UIColor(named: "BoldLabelsColor")!
            ])
        
        view?.pieChart.centerAttributedText = centerText
        
        var entries = [PieChartDataEntry]()
        var colors = [UIColor]()
        for (category, value) in dict.0{
            if value != 0{
                entries.append(PieChartDataEntry(value: value * 100))
                colors.append(CategoryCostsDesignElements().getCategoryColors()[category]!)
            }
        }
        
        let set = PieChartDataSet(entries: entries, label: String())
        let data = PieChartData(dataSet: set)
        set.colors = colors
        view?.pieChart.data = data
    }
    
//    func getYearStatistics(){
//        let dict = GetCostStatistic().getYearPercent()
//        var array: [CostCategoryModel] = []
//        var persents = 0
//        for (category, value) in dict.0{
//            let percent = Int(round(value * 100) / 100 * 100)
//            if value != 0{
//                array.append(CostCategoryModel(costsSum: dict.1[category]!, percents: percent, category: Categories(rawValue: String(category))!, color: CategoryCostsDesignElements().getCategoryColors()[category]!))
//            }
//        }
//        
//        array = array.sorted(by: { model1, model2 in
//            model1.percents > model2.percents
//        })
//        
//        if array.isEmpty {
//            isCategoryEmpty.on(.next(true))
//        } else {
//            isCategoryEmpty.on(.next(false))
//        }
//        
//        categories.on(.next([SectionModel(model: "Категории Расходов", items: array)]))
//        
//    }
}
