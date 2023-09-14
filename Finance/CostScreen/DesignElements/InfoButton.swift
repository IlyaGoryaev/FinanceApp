import UIKit

class InfoButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpStyle()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension InfoButton{
    
    func setUpStyle(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        self.tintColor = UIColor(named: "BoldLabelsColor")
        self.titleLabel?.font = .boldSystemFont(ofSize: 30)
        self.backgroundColor = UIColor(named: "FinanaceMainScreenCellColor")
        self.layer.cornerRadius = 25
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        self.layer.shadowRadius = 15
    }
    
    
}
