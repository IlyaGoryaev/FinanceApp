import UIKit

protocol IncomeScreenDelegate: AnyObject{
    func didTapButtonMenu()
}

class IncomeScreen: UIViewController {
    
    weak var delegate: IncomeScreenDelegate?
    
    //MARK: Кнопка бокового меню
    let menuIcon = MenuIcon()
    
    //MARK: Кнопки периода
    let buttons = Buttons()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Настройка кнопок периода
        buttons.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttons)
        NSLayoutConstraint.activate([
            buttons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttons.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        ])
        
        setupMenuButton()

    }
    
    
    
    //MARK: Настройка кнопки меню
    func setupMenuButton(){
        menuIcon.translatesAutoresizingMaskIntoConstraints = false
        menuIcon.backgroundColor = .white
        view.addSubview(menuIcon)
        NSLayoutConstraint.activate([
            menuIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            menuIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuIcon.heightAnchor.constraint(equalToConstant: 50),
            menuIcon.widthAnchor.constraint(equalToConstant: 50)
        ])
        let tapMenuIconGesture = UITapGestureRecognizer(target: self, action: #selector(tappedMenuButton))
        menuIcon.addGestureRecognizer(tapMenuIconGesture)
    }
    
    @objc func tappedMenuButton(){
        self.delegate?.didTapButtonMenu()
    }
    
}
