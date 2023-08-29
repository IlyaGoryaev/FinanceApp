import UIKit
import Foundation

class Buttons: UIStackView{
    
    let buttonDay = UIButton()
    let buttonMonth = UIButton()
    let buttonYear = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonDay.setTitle("День", for: .normal)
        buttonMonth.setTitle("Месяц", for: .normal)
        buttonYear.setTitle("Год", for: .normal)
        buttonDay.titleLabel?.font = .boldSystemFont(ofSize: 35)
        buttonMonth.titleLabel?.font = .boldSystemFont(ofSize: 35)
        buttonYear.titleLabel?.font = .boldSystemFont(ofSize: 35)
        buttonDay.setTitleColor(UIColor(named: "BoldLabelsColor"), for: .normal)
        buttonMonth.setTitleColor(UIColor(named: "MainScreenButtonsColor2"), for: .normal)
        buttonYear.setTitleColor(UIColor(named: "MainScreenButtonsColor2"), for: .normal)
        axis = .horizontal
        spacing = 15
        alignment = .center
        distribution = .equalSpacing
        [self.buttonDay, self.buttonMonth, self.buttonYear].forEach {
            addArrangedSubview($0)
        }
        
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
