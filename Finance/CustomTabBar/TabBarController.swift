import UIKit

class TabBarController: UITabBarController {
    
    let roundLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = .clear
        tabBar.shadowImage = UIImage()
        setupTabBar()
        setupTabBarAppearence()
        navigationController?.navigationBar.isHidden = true
        let theme = Theme(rawValue: UserDefaults.standard.integer(forKey: "app_theme"))
        theme?.save()
    }
    
    private func setupTabBar(){
        let settingNavigationController = UINavigationController()
        settingNavigationController.viewControllers = [SettingsScreen()]
        viewControllers = [
            generateVc(viewController: CostScreen(), title: "Расходы", image: UIImage(systemName: "arrow.down.forward")),
            generateVc(viewController: IncomeScreen(), title: "Доходы", image: UIImage(systemName: "arrow.up.forward")),
            generateVc(viewController: FinanceStatisticsScreen(), title: "Анализ", image: UIImage(systemName: "cellularbars")),
            generateVc(viewController: settingNavigationController, title: "Настройки", image: UIImage(systemName: "gearshape"))
        ]
    }
    
    private func generateVc(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController{
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func setupTabBarAppearence(){
        let positionOnX: CGFloat = 20
        let positionOnY: CGFloat = 10
        let width = tabBar.bounds.width - positionOnX * 4
        let height = tabBar.bounds.height + positionOnY * 2
        
        
        roundLayer.fillColor = UIColor(named: "FinanaceMainScreenCellColor")?.cgColor
        roundLayer.shadowOpacity = 0.2
        roundLayer.shadowRadius = 20
        roundLayer.shadowOffset = .zero
        roundLayer.shadowColor = UIColor.black.cgColor
        
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: positionOnX * 2, y: tabBar.bounds.minY - positionOnY, width: width, height: height - 5), cornerRadius: height / 2)
        
        roundLayer.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        
        tabBar.itemWidth = width / 6.5
        tabBar.itemPositioning = .centered
        
        tabBar.tintColor = UIColor(named: "BoldLabelsColor")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.roundLayer.fillColor = UIColor(named: "FinanaceMainScreenCellColor")?.cgColor
    }

}
