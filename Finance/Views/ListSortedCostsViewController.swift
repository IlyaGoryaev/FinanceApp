import RxCocoa
import RxSwift
import RxDataSources
import UIKit
//Реализовать период
class ListSortedCostsViewController: UIViewController, UIScrollViewDelegate {
    
    let disposeBag = DisposeBag()
    
    let viewModel = ListSortedCostsViewModel()
    
    var category: String?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(category: String, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.category = category
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var table: UITableView = {
        let table = UITableView(frame: CGRect(), style: .grouped)
        table.frame = self.view.frame
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(table)
        bindTable()
        viewModel.fetchData(category: category!)
        print(try! viewModel.array.value())
        print(table.numberOfRows(inSection: 0))
    }
            
        func bindTable(){
            table.rx.setDelegate(self).disposed(by: disposeBag)
                    
            let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CostRealm>>{_, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
                cell.textLabel?.text = String(item.sumCost)
                cell.detailTextLabel?.text = item.description
                cell.backgroundColor = .systemGray4
                return cell
            }
            self.viewModel.array.bind(to: self.table.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        }
}
