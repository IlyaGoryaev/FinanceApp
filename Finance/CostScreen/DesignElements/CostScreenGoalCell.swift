import UIKit

class CostScreenGoalCell: UICollectionViewCell {
    
    let pictureLabel = UILabel()
    let nameLabel = UILabel()
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension CostScreenGoalCell{
    
    func setupComponents(){
        
        pictureLabel.font = .systemFont(ofSize: 40)
        nameLabel.textColor = .gray
        
    }
    
    func setupStackView(){
        
        setupComponents()
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        
        [self.nameLabel, self.pictureLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
    }
    
    
}
