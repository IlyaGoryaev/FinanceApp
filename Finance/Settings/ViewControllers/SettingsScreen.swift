import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SettingsScreen: UIViewController, UIScrollViewDelegate {
    
    let settingsLabel = UILabel()
    
    let disposeBag = DisposeBag()
    
    lazy var table: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        table.allowsSelection = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        bindTable()

        
        settingsLabel.text = "Настройки"
        settingsLabel.font = .boldSystemFont(ofSize: 40)
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsLabel)
        NSLayoutConstraint.activate([
            settingsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            settingsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        
    }
    
    func setUpTableView(){
        self.view.addSubview(table)
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    private func bindTable(){
        
        let data = Observable.just(["Оформление", "Уведомления", "Подписка", "О приложении", "Обратная связь"])
        data.bind(to: table.rx.items){ tableView, index, item in
            let indexPath = IndexPath(item: index, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            cell.label.text = item
            print(item)
            return cell
        }.disposed(by: disposeBag)
        
        table.rx.setDelegate(self).disposed(by: disposeBag)
        
    }
}
