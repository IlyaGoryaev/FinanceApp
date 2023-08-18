
import UIKit

protocol SettingsScreenProtocol: AnyObject{
    func didTapButtonMenu()
}

class SettingsScreen: UIViewController {

    //MARK: Кнопка бокового меню
    let menuIcon = MenuIcon()

    weak var delegate: SettingsScreenProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @objc func tappedMenuButton(){
        self.delegate?.didTapButtonMenu()
    }


}
