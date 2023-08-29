import RxCocoa
import RxSwift
import RxDataSources
import UIKit


class ListSortedIncomesViewController: UIViewController, UIScrollViewDelegate {

    let disposeBag = DisposeBag()
    
    let viewModel = ListSortedIncomesViewModel()
    
    var category: String?
    
    var periodId: Int?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(category: String, periodId: Int, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
        table.register(IncomeCell.self, forCellReuseIdentifier: "Cell")
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
                    
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, IncomeRealm>>{_, tableView, indexPath, item in

                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! IncomeCell
                cell.labelIncome.text = "\(item.sumIncome)₽"
                cell.labelCategory.text = CategoryIncomeDesignElements().getRussianLabelText()[item.category]
                cell.labelComment.text = item.label
                cell.labelIncome.font = .boldSystemFont(ofSize: 20)
                cell.labelCategory.font = .italicSystemFont(ofSize: 15)
                cell.categoryColorView.backgroundColor = CategoryIncomeDesignElements().getCategoryColors()[item.category]
                cell.emojiLabel.text = CategoryIncomeDesignElements().getCategoryEmoji()[item.category]
                
                cell.labelCategory.textColor = UIColor(named: "SemiBoldColor")
                cell.labelComment.textColor = UIColor(named: "BoldLabelsColor")
                return cell
            }
            self.viewModel.array.bind(to: self.table.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        }

}
