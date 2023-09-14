import UIKit
import RxSwift
import RxCocoa
import RxDataSources
class SettingsScreen: UIViewController, UIScrollViewDelegate {
            
    let disposeBag = DisposeBag()
    
    let viewModel = SettingsViewModel()
    
    lazy var table: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "FinanceBackgroundColor")
        title = "Настройки"
        navigationController?.navigationBar.prefersLargeTitles = true
        setUpTableView()
        bindTable()
    }
    //MARK: убрать
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setUpTableView(){
        self.view.addSubview(table)
        table.backgroundColor = UIColor(named: "FinanceBackgroundColor")
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    private func bindTable(){
        
        let data = Observable.just(["Оформление", "О приложении", "Обратная связь"])
        data.bind(to: table.rx.items){ tableView, index, item in
            let indexPath = IndexPath(item: index, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            cell.label.text = item
            cell.label.textColor = UIColor(named: "BoldLabelsColor")
            return cell
        }.disposed(by: disposeBag)
        
        table.rx.setDelegate(self).disposed(by: disposeBag)
        
        table.rx.itemSelected.subscribe {
            switch $0.element!.row{
            case 0:
                let vc = ThemeViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 1:
                let vc = UIViewController()
                vc.view.backgroundColor = .gray
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 2:
                let vc = UIViewController()
                vc.view.backgroundColor = .gray
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 3:
                let vc = UIViewController()
                vc.view.backgroundColor = .gray
                self.navigationController?.pushViewController(vc, animated: true)
                break
            default:
                break
            }
        }.disposed(by: disposeBag)
        
    }
}
