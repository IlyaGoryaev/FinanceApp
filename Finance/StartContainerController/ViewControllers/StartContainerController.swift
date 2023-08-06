import UIKit
//Дублтрование costViewController исправить
class StartContainerController: UIViewController{
    
    enum MenuState{
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
    
    let menuVC = MenuViewController()
    lazy var costVC = CostScreen()
    lazy var costViewController = CostScreen()
    lazy var incomeVC = IncomeScreen()
    lazy var financeGoalVC = FinanceGoalsScreen()
    lazy var financeStatistics = FinanceStatisticsScreen()
    lazy var Settings = SettingsScreen()
    
    var previousController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildControllers()
    }
    
    private func addChildControllers(){
        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        costViewController.delegate = self
        addChild(costViewController)
        view.addSubview(costViewController.view)
        costViewController.didMove(toParent: self)
    }
}
extension StartContainerController: CostScreenDelegate, IncomeScreenDelegate, FinanceGoalsScreenProtocol, FinanceStatisticsScreenProtocol, SettingsScreenProtocol{
    func didTapButtonMenu() {
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?){
        switch menuState{
        case .opened:
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                self.costViewController.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done{
                    self?.menuState = .closed
                }
            }
        case .closed:
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                self.costViewController.view.frame.origin.x = self.costViewController.view.frame.size.width - 170
            } completion: { [weak self] done in
                if done{
                    self?.menuState = .opened
                }
            }

        }
    }
}
extension StartContainerController: MenuViewControllerDelegate{
    func didSelect(menuItem: MenuViewController.MenuOptions) {
        toggleMenu(completion: nil)
        
        switch menuItem{
            
        case .cost:
            addCostVC()
            break
        case .income:
            addIncomeVC()
            break
        case .financeGoal:
            addFinanceGoalsVC()
            break
        case .statistics:
            addFinanceStatisticsGoalsVC()
            break
        case .settings:
            addSettingsVC()
            break
        }
    }
    
    func addIncomeVC(){
        let vc = incomeVC
        incomeVC.delegate = self
        vc.view.backgroundColor = .white
        costViewController.addChild(vc)
        costViewController.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: self)
    }
    
    func addCostVC(){
        let vc = costVC
        vc.delegate = self
        costViewController.addChild(vc)
        costViewController.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: self)
    }
    
    func addFinanceGoalsVC(){
        let vc = financeGoalVC
        vc.delegate = self
        vc.view.backgroundColor = .white
        costViewController.addChild(vc)
        costViewController.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: self)
    }
    
    func addFinanceStatisticsGoalsVC(){
        let vc = financeStatistics
        vc.delegate = self
        vc.view.backgroundColor = .white
        costViewController.addChild(vc)
        costViewController.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: self)
    }
    
    func addSettingsVC(){
        let vc = Settings
        vc.delegate = self
        vc.view.backgroundColor = .white
        costViewController.addChild(vc)
        costViewController.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: self)
    }
    
}
