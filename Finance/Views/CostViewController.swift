
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CostViewController: UIViewController {
    
    
    private var viewModel = CostModelView()
    
    lazy var table: UITableView = {
        let table = UITableView()
        table.frame = self.view.frame
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CostCell.self, forCellReuseIdentifier: "CostCell")
        return table
    }()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(table)
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.1716541946, green: 0.1766330898, blue: 0.1461265981, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 0.1716541946, green: 0.1766330898, blue: 0.1461265981, alpha: 1)
        let addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(tappedAddButton))
        self.navigationItem.rightBarButtonItem = addButton
        let exitButton = UIBarButtonItem(title: "Exit", style: .done, target: self, action: #selector(tappedExitButton))
        self.navigationItem.leftBarButtonItem = exitButton
        title = "Расходы"
        bindTable()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchCosts()
    }
    
    @objc func tappedExitButton(){
        dismiss(animated: true)
    }
    
    @objc func tappedAddButton(){
        let addViewController = AddCostViewController()
        addViewController.modalPresentationStyle = .fullScreen
        self.present(addViewController, animated: true)
    }
}
extension CostViewController: UIScrollViewDelegate{
    
    func bindTable(){
        table.rx.setDelegate(self).disposed(by: disposeBag)
                
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CostRealm>>{_, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CostCell", for: indexPath) as! CostCell
            cell.label1.text = String(item.sumCost)
            cell.label2.text = item.category
            return cell
        } titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        }
        
        self.viewModel.costs.bind(to: self.table.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
}
