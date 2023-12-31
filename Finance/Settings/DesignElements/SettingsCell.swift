
import UIKit

class SettingsCell: UITableViewCell {
    
    let view = UIView()
    let label = UILabel()

    let arrowImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "SettingsCell")
        self.selectionStyle = .none
        styleCell()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension SettingsCell{
    
    private func styleCell(){
        self.backgroundColor = UIColor(named: "FinanceBackgroundColor")
        view.backgroundColor = UIColor(named: "FinanaceMainScreenCellColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.text = "Настройки"
        label.font = .boldSystemFont(ofSize: 20)
        
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        arrowImage.image = UIImage(named: "vector-3")
        arrowImage.transform = arrowImage.transform.rotated(by: .pi)
        arrowImage.tintColor = UIColor(named: "BoldLabelsColor")
        
    }
    
    private func layout(){
        
        addSubview(view)
        addSubview(label)
        addSubview(arrowImage)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 70),
            view.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            arrowImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.view.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
    }
    
}
