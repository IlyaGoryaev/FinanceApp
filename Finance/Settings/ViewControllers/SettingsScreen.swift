import UIKit
import RxSwift
import RxCocoa
import RxDataSources
class SettingsScreen: UIViewController, UIScrollViewDelegate {
    
    let settingsLabel = UILabel()
    
    let synchronizationView = UIView()
    
    let disposeBag = DisposeBag()
    
    let label = UILabel()
    
    let viewModel = SettingsViewModel()
    
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
        setupSynchronizationView()

        
        settingsLabel.text = "Настройки"
        settingsLabel.font = .boldSystemFont(ofSize: 40)
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsLabel)
        NSLayoutConstraint.activate([
            settingsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            settingsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        
    }
    //MARK: убрать
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUID()
        if try! viewModel.authUID.value() != ""{
            label.text = try! viewModel.authUID.value()
        } else {
            label.text = "Синхронизация"
        }
    }
    
    func setUpTableView(){
        self.view.addSubview(table)
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
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
    
    func setupSynchronizationView(){
        synchronizationView.backgroundColor = .red
        synchronizationView.layer.cornerRadius = 10
        synchronizationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(synchronizationView)
        NSLayoutConstraint.activate([
            synchronizationView.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            synchronizationView.heightAnchor.constraint(equalToConstant: 80),
            synchronizationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            synchronizationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 145)
        ])
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        synchronizationView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: synchronizationView.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: synchronizationView.centerXAnchor)
        ])
        
        
        
        
        label.textColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedSynchronizationView))
        synchronizationView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tappedSynchronizationView(){
        let viewController = LoginViewController()
        viewController.view.backgroundColor = .white
        present(viewController, animated: true)
    }
}
