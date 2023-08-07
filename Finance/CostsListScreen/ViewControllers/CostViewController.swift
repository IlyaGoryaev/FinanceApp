
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CostViewController: UIViewController {
    
    
    private var viewModel = CostModelView()
    
    let exitButton = UIButton()
    let addButton = UIButton()
    
    let segmentControl = UISegmentedControl(items: ["Cегодня", "Неделя", "Месяц"])
    
    lazy var table: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CostCell.self, forCellReuseIdentifier: "CostCell")
        table.allowsSelection = false
        return table
    }()
    
    
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        view.backgroundColor = #colorLiteral(red: 0.1716541946, green: 0.1766330898, blue: 0.1461265981, alpha: 1)
        navigationController?.navigationBar.isHidden = true
        bindTable()
        setUpButtons()
        setupSegmentControl()
        
    }
    
    func setupSegmentControl(){
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = .white
        segmentControl.tintColor = .gray
        segmentControl.selectedSegmentTintColor = #colorLiteral(red: 1, green: 0.9999921918, blue: 0.3256074786, alpha: 1)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentControl)
        NSLayoutConstraint.activate([
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentControl.bottomAnchor.constraint(equalTo: table.topAnchor, constant: -8),
            segmentControl.heightAnchor.constraint(equalToConstant: 30)
        ])
        segmentControl.addTarget(self, action: #selector(changeValue(sender: )), for: .valueChanged)
    }
    
    @objc func changeValue(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex{
        case 0:
            viewModel.fetchDayCosts()
            break
        case 1:
            viewModel.fetchWeekCosts()
            break
        case 2:
            viewModel.fetchMonthCosts()
            break
        default:
            break
        }
    }
    
    func setUpButtons(){
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.setTitle("←", for: .normal)
        exitButton.titleLabel?.font = .systemFont(ofSize: 30)
        exitButton.backgroundColor = .white
        exitButton.setTitleColor(.gray, for: .normal)
        exitButton.layer.cornerRadius = 25
        exitButton.layer.shadowOpacity = 0.4
        exitButton.layer.shadowColor = UIColor.gray.cgColor
        
        view.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            exitButton.widthAnchor.constraint(equalToConstant: 50),
            exitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        exitButton.addTarget(self, action: #selector(tappedExitButton), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 30)
        addButton.backgroundColor = .white
        addButton.setTitleColor(.gray, for: .normal)
        addButton.layer.cornerRadius = 25
        addButton.layer.shadowOpacity = 0.4
        addButton.layer.shadowColor = UIColor.gray.cgColor
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        addButton.addTarget(self, action: #selector(tappedAddButton), for: .touchUpInside)
    }
    
    func setUpTableView(){
        self.view.addSubview(table)
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchDayCosts()
    }
    
    @objc func tappedExitButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tappedAddButton(){
        let addViewController = AddCostController()
        //addViewController.modalPresentationStyle = .fullScreen
        self.present(addViewController, animated: true)
    }
}
extension CostViewController: UIScrollViewDelegate{
    
    func bindTable(){
        table.rx.setDelegate(self).disposed(by: disposeBag)
                
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CostRealm>>{_, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CostCell", for: indexPath) as! CostCell
            cell.labelCost.text = "\(item.sumCost)₽"
            cell.labelCategory.text = CategoryCostsDesignElements().getRussianLabelText()[item.category]
            cell.labelComment.text = item.label
            cell.labelCost.font = .boldSystemFont(ofSize: 20)
            cell.labelCategory.font = .italicSystemFont(ofSize: 15)
            cell.categoryColorView.backgroundColor = CategoryCostsDesignElements().getCategoryColors()[item.category]
            cell.emojiLabel.text = CategoryCostsDesignElements().getCategoryEmoji()[item.category]
            return cell
        } titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        }
        
        table.rx.itemDeleted.subscribe { indexPath in
            //Удаление
        }.disposed(by: disposeBag)
        
        self.viewModel.costs.bind(to: self.table.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
}
