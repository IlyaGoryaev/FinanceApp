import UIKit

class CellForCostScreen: UICollectionViewCell {
    
    let sumLabel = UILabel()
    let categoryLabel = UILabel()
    let percentLabel = UILabel()
    let colorImage = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        sumLabel.font = .boldSystemFont(ofSize: 17)
        sumLabel.textColor = .gray
        categoryLabel.font = .systemFont(ofSize: 14)
        categoryLabel.textColor = .systemGray2
        sumLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        colorImage.layer.cornerRadius = 8
        colorImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(colorImage)
        addSubview(sumLabel)
        addSubview(categoryLabel)
        addSubview(percentLabel)
        percentLabel.font = .systemFont(ofSize: 17)
        percentLabel.textColor = .gray
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            sumLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            sumLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoryLabel.topAnchor.constraint(equalTo: sumLabel.bottomAnchor, constant: 5),
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            colorImage.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            colorImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            colorImage.widthAnchor.constraint(equalToConstant: 16),
            colorImage.heightAnchor.constraint(equalToConstant: 16),
            percentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            percentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
