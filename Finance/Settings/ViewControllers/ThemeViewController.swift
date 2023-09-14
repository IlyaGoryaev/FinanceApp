import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import SnapKit

class ThemeViewController: UIViewController, UIScrollViewDelegate {
    
    let viewModel = ThemeViewModel()
    
    let disposeBag = DisposeBag()
    
    lazy var table: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ThemeCell.self, forCellReuseIdentifier: "ThemeCell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "FinanceBackgroundColor")
        title = "Оформление"
        setupTableView()
        bindTableView()
    }
    
}
extension ThemeViewController{
    
    private func setupTableView(){
        
        table.backgroundColor = UIColor(named: "FinanceBackgroundColor")
        view.addSubview(table)
        table.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaInsets.bottom)
        }
    }
    
    private func bindTableView(){
        
        let data = Observable.just(["Системное", "Темное", "Светлое"])
        
        data.bind(to: table.rx.items){ tableView, index, item in
            let indexPath = IndexPath(item: index, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell", for: indexPath) as! ThemeCell
            cell.label.text = item
            let themeId = UserDefaults.standard.integer(forKey: "app_theme")
            if index == themeId{
                cell.doneView.backgroundColor = .green
            }
            return cell
        }.disposed(by: disposeBag)
        
        table.rx.itemSelected.subscribe {
            let prevCell = self.table.cellForRow(at: IndexPath(row: UserDefaults.standard.integer(forKey: "app_theme"), section: 0)) as! ThemeCell
            prevCell.doneView.backgroundColor = .white
            let cell = self.table.cellForRow(at: $0.element!) as! ThemeCell
            cell.doneView.backgroundColor = .green
            guard let theme = Theme(rawValue: $0.element!.row) else { return }
            theme.setActive()
        }.disposed(by: disposeBag)
        table.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
}
