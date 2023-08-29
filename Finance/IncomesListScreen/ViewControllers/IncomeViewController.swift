import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class IncomeViewController: UIViewController {
    
    private var viewModel = IncomeModelView()

    let exitButton = UIButton()
    let addButton = UIButton()
    
    let segmentControl = UISegmentedControl(items: ["Cегодня", "Неделя", "Месяц"])
    
    lazy var table: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor(named: "FinanceBackgroundColor")
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(IncomeCell.self, forCellReuseIdentifier: "IncomeCell")
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.fetchDayIncomes()
    }
    
    func setupSegmentControl(){
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = .white
        segmentControl.tintColor = .gray
        segmentControl.selectedSegmentTintColor = #colorLiteral(red: 1, green: 0.9999921918, blue: 0.3256074786, alpha: 1)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        let titleTextAttributesForNormal = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        segmentControl.setTitleTextAttributes(titleTextAttributesForNormal, for: .normal)
        let titleTextAttributesForSelected = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1716541946, green: 0.1766330898, blue: 0.1461265981, alpha: 1)]
        segmentControl.setTitleTextAttributes(titleTextAttributesForSelected, for: .selected)
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
            viewModel.fetchDayIncomes()
            viewModel.selectedIndex.on(.next(0))
            print(try! viewModel.incomes.value())
            break
        case 1:
            viewModel.fetchWeekIncomes()
            viewModel.selectedIndex.on(.next(1))
            print(try! viewModel.incomes.value())
            break
        case 2:
            viewModel.fetchMonthIncomes()
            viewModel.selectedIndex.on(.next(2))
            print(try! viewModel.incomes.value())
            break
        default:
            break
        }
    }
    
    func setUpButtons(){
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.setTitle("←", for: .normal)
        exitButton.titleLabel?.font = .systemFont(ofSize: 30)
        exitButton.backgroundColor = UIColor(named: "FinanaceMainScreenCellColor")
        exitButton.setTitleColor(UIColor(named: "SemiBoldColor"), for: .normal)
        exitButton.layer.cornerRadius = 25
        
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
        addButton.backgroundColor = UIColor(named: "FinanaceMainScreenCellColor")
        addButton.setTitleColor(UIColor(named: "SemiBoldColor"), for: .normal)
        addButton.layer.cornerRadius = 25
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
    
    @objc func tappedExitButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tappedAddButton(){
        let addViewController = AddIncomeViewController()
        
        let addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.backgroundColor = .systemGray4
        addViewController.view.addSubview(addButton)
        addButton.layer.cornerRadius = 25
        addButton.layer.shadowOpacity = 0.15
        addButton.layer.shadowOffset = .zero
        addButton.layer.shadowRadius = 10
        addButton.layer.shouldRasterize = true
        addButton.setTitle("✓", for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 30)
        addButton.setTitleColor(.gray, for: .normal)
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.trailingAnchor.constraint(equalTo: addViewController.view.trailingAnchor, constant: -16),
            addButton.topAnchor.constraint(equalTo: addViewController.view.topAnchor, constant: 16)
        ])
        
        addViewController.viewModel.isButtonAble.subscribe {
            if $0.element! == true{
                addButton.backgroundColor = .green
                addButton.isEnabled = true
            } else {
                addButton.backgroundColor = .systemGray4
                addButton.isEnabled = false
            }
        }.disposed(by: disposeBag)
        
        addButton.addAction(UIAction(handler: { _ in
            self.dismiss(animated: true)
            let selectedItem = try! addViewController.viewModel.selectedItem.value()
            let sum = try! addViewController.viewModel.sum.value()
            let typeOfSelectedItem = try! addViewController.viewModel.typeOfSelectedItem.value()
            var stringSelectedItem = ""
            for item in selectedItem.keys{
                    for (category, item) in CategoryIncomeDesignElements().getCategoryEmoji(){
                        if item == typeOfSelectedItem{
                            stringSelectedItem = category
                        }
                    }
                    
                    addViewController.viewModel.newValuesForIncome(sumCost: sum, category: stringSelectedItem, label: "Income", date: try! addViewController.viewModel.dateSelected.value())
                    addViewController.viewModel.saveRealmIncome()
                    print(try! addViewController.viewModel.dateSelected.value())
                    
            }
            
            
            self.viewModel.fetchObjectsAfterAddingNewIncome()
            
            
        }), for: .touchUpInside)
        
        self.present(addViewController, animated: true)
    }
    
}
extension IncomeViewController: UIScrollViewDelegate{
    
    func bindTable(){
        table.rx.setDelegate(self).disposed(by: disposeBag)
                
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, IncomeRealm>>{_, tableView, indexPath, item in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeCell", for: indexPath) as! IncomeCell
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
            
        } titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        }
        
        table.rx.itemDeleted.subscribe { indexPath in
            //Удаление
        }.disposed(by: disposeBag)
        
        self.viewModel.incomes.bind(to: self.table.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    
    
}
