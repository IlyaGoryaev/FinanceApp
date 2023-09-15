import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import DGCharts

class CostScreenViewModel{
    
    let view: ScreenProtocol?
    
    let categories = BehaviorSubject(value: [SectionModel(model: "", items: [CostCategoryModel]())])
    let isCategoryEmpty = BehaviorSubject(value: true)
    let costDescription = BehaviorSubject(value: CostScreenModel())
    
    init(viewController: ScreenProtocol){
        self.view = viewController
    }
    
    func setUpScreen(periodId: Period){
        var array: [CostCategoryModel] = []
        
        let dict: ([Categories.RawValue : Double], [Categories.RawValue : Int])
        let sumCost: Int
        
        switch periodId{
        case .Day:
            dict = GetCostStatistic().getDayPercent(dateComponents: GetCurrentDateComponents.get.day())
            sumCost = CostStorageService().fetchSumCurrentDay()
        case .Month:
            dict = GetCostStatistic().getMonthPercent(dateComponents: GetCurrentDateComponents.get.month())
            sumCost = CostStorageService().fetchSumCurrentMonth()
        case .Year:
            dict = GetCostStatistic().getYearPercent()
            sumCost = CostStorageService().fetchSumCurrentYear()
        }
        
        var entries = [PieChartDataEntry]()
        var colors = [UIColor]()
        
        for (category, value) in dict.0{
            let percent = Int(round(value * 100) / 100 * 100)
            if value != 0{
                array.append(CostCategoryModel(costsSum: dict.1[category]!, percents: percent, category: Categories(rawValue: String(category))!, color: CategoryCostsDesignElements().getCategoryColors()[category]!))
                entries.append(PieChartDataEntry(value: value * 100))
                entries.last?.data = category
                colors.append(CategoryCostsDesignElements().getCategoryColors()[category]!)
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
        let costScreenModel = CostScreenModel(date: Date(), costPeriod: periodId, sumCost: sumCost, categories: array)
        costDescription.on(.next(costScreenModel))
    }
}
