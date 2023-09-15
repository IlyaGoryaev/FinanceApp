import RxCocoa
import RxSwift
import RxDataSources
import UIKit

final class ListSortedCostsViewController: UIViewController, UIScrollViewDelegate {
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = ListSortedCostsViewModel()
    
    var category: String?
    
    var periodId: Period?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(category: String, periodId: Period, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.category = category
        self.periodId = periodId
        self.view.backgroundColor = UIColor(named: "FinanceBackgroundColor")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var table: UITableView = {
        let table = UITableView(frame: CGRect(), style: .grouped)
        table.backgroundColor = UIColor(named: "FinanceBackgroundColor")
        table.frame = self.view.frame
        table.separatorStyle = .none
        table.allowsSelection = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CostCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(table)
        bindTable()
        viewModel.fetchData(category: category!, periodId: periodId!)
    }
            
        func bindTable(){
            table.rx.setDelegate(self).disposed(by: disposeBag)
                    
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CostRealm>>{_, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CostCell
                cell.labelCost.text = "\(item.sumCost)₽"
                cell.labelCategory.text = CategoryCostsDesignElements().getRussianLabelText()[item.category]
                cell.labelComment.text = item.label
                cell.labelCost.font = .boldSystemFont(ofSize: 20)
                cell.labelCategory.font = .italicSystemFont(ofSize: 15)
                cell.categoryColorView.backgroundColor = CategoryCostsDesignElements().getCategoryColors()[item.category]
                cell.emojiLabel.text = CategoryCostsDesignElements().getCategoryEmoji()[item.category]
                
                cell.labelCategory.textColor = UIColor(named: "SemiBoldColor")
                cell.labelComment.textColor = UIColor(named: "BoldLabelsColor")
                return cell
            }
            self.viewModel.array.bind(to: self.table.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        }
}
