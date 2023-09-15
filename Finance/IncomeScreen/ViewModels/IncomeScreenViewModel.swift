import UIKit
import DGCharts
import RxCocoa
import RxSwift
import RxDataSources

class IncomeScreenViewModel{
    
    let view: ScreenProtocol?
    
    let categories = BehaviorSubject(value: [SectionModel(model: "", items: [IncomeCategoryModel]())])
    let isCategoryEmpty = BehaviorSubject(value: true)
    let incomeDescription = BehaviorSubject(value: IncomeScreenModel())
    
    
    init(viewController: ScreenProtocol){
        self.view = viewController
    }
    
    func setUpScreen(periodId: Period){
        var array: [IncomeCategoryModel] = []
        
        let dict: ([IncomeCategories.RawValue : Double], [IncomeCategories.RawValue : Int])
        let sumIncome: Int
        
        switch periodId{
        case .Day:
            dict = GetIncomeStatistic().getDayPercent(dateComponents: GetCurrentDateComponents.get.day())
            sumIncome = IncomeStorageService().fetchSumCurrentDay()
        case .Month:
            dict = GetIncomeStatistic().getMonthPercent(dateComponents: GetCurrentDateComponents.get.month())
            sumIncome = IncomeStorageService().fetchSumCurrentMonth()
        case .Year:
            dict = GetIncomeStatistic().getYearPercent()
            sumIncome = IncomeStorageService().fetchSumCurrentYear()
        }
        
        var entries = [PieChartDataEntry]()
        var colors = [UIColor]()
        
        for (category, value) in dict.0{
            let percent = Int(round(value * 100) / 100 * 100)
            if value != 0{
                array.append(IncomeCategoryModel(incomeSum: dict.1[category]!, percents: percent, category: IncomeCategories(rawValue: String(category))!, color: CategoryIncomeDesignElements().getCategoryColors()[category]!))
                entries.append(PieChartDataEntry(value: value * 100))
                entries.last?.data = category
                colors.append(CategoryIncomeDesignElements().getCategoryColors()[category]!)
            }
        }
        
        let set = PieChartDataSet(entries: entries)
        set.valueFont = .systemFont(ofSize: 16, weight: .heavy)
        set.valueTextColor = NSUIColor(cgColor: UIColor(named: "ColorPieChartsLabels")!.cgColor)
        let data = PieChartData(dataSet: set)
        set.colors = colors
        view?.pieChart.data = data
        array = array.sorted { model1, model2 in
            model1.percents > model2.percents
        }
        
        isCategoryEmpty.on(.next(array.isEmpty))
        categories.on(.next([SectionModel(model: "Категории Расходов", items: array)]))
        let incomeScreenModel = IncomeScreenModel(period: periodId, date: Date(), sumIncome: sumIncome, categories: array)
        incomeDescription.on(.next(incomeScreenModel))
    }
}

