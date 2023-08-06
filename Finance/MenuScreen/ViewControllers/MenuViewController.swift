import RxCocoa
import RxSwift
import RxDataSources
import UIKit

protocol MenuViewControllerDelegate: AnyObject{
    func didSelect(menuItem: MenuViewController.MenuOptions)
}

class MenuViewController: UIViewController{
    
    var tableView: UITableView!
    
    enum MenuOptions: String, CaseIterable{
        case cost = "Расходы"
        case income = "Доходы"
        case financeGoal = "Финансовые цели"
        case statistics = "Аналитика финансов"
        case settings = "Настройки"
    }
            
    weak var delegate: MenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
        configureTableView()

    }
    
    private func configureTableView(){
        tableView = UITableView()
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.frame = self.view.frame
        tableView.rowHeight = 80
        tableView.backgroundColor = #colorLiteral(red: 0.187341392, green: 0.1923195124, blue: 0.1618330479, alpha: 1)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

}
extension MenuViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
        cell.label.text = MenuOptions.allCases[indexPath.row].rawValue
        cell.label.font = .boldSystemFont(ofSize: 18)
        cell.backgroundColor = #colorLiteral(red: 0.187341392, green: 0.1923195124, blue: 0.1618330479, alpha: 1)
        cell.label.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = MenuOptions.allCases[indexPath.row]
        delegate?.didSelect(menuItem: item)
    }
}
