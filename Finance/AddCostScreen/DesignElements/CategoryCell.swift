import UIKit
import SnapKit

class CategoryCell: UICollectionViewCell {
    
    let label = UILabel()
    let greenView = UIView()
    let labelSelected = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "ColorForAddScreen")!
        label.translatesAutoresizingMaskIntoConstraints = false
        greenView.translatesAutoresizingMaskIntoConstraints = false
        labelSelected.translatesAutoresizingMaskIntoConstraints = false
        greenView.backgroundColor = .green
        greenView.layer.cornerRadius = 15
        labelSelected.text = "✔️"
        labelSelected.textColor = .white
        addSubview(label)
        addSubview(greenView)
        addSubview(labelSelected)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            greenView.centerXAnchor.constraint(equalTo: centerXAnchor),
            greenView.centerYAnchor.constraint(equalTo: centerYAnchor),
            greenView.widthAnchor.constraint(equalToConstant: 30),
            greenView.heightAnchor.constraint(equalToConstant: 30),
            labelSelected.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelSelected.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        greenView.isHidden = true
        labelSelected.isHidden = true
        setUpUnSelectedStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension CategoryCell{
    
    func setUpUnSelectedStyle(){
        self.backgroundColor = UIColor(named: "ColorForAddScreen")!
        self.layer.shadowOpacity = 0
    }
    
    func setUpSelectedStyle(){
        self.backgroundColor = .white
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 8
    }
    
}
