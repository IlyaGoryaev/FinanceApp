import UIKit

final class SegmentedControlForList: UISegmentedControl {

    override init(items: [Any]?) {
        super.init(items: items)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
private extension SegmentedControlForList{
    
    func setupStyle(){
        self.selectedSegmentIndex = 0
        self.backgroundColor = .white
        self.tintColor = .gray
        self.selectedSegmentTintColor = #colorLiteral(red: 1, green: 0.9999921918, blue: 0.3256074786, alpha: 1)
        let titleTextAttributesForNormal = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        self.setTitleTextAttributes(titleTextAttributesForNormal, for: .normal)
        let titleTextAttributesForSelected = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1716541946, green: 0.1766330898, blue: 0.1461265981, alpha: 1)]
        self.setTitleTextAttributes(titleTextAttributesForSelected, for: .selected)
    }
    
}
