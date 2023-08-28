
import UIKit

class SettingsCell: UITableViewCell {
    
    let view = UIView()
    let label = UILabel()

    let arrowImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "SettingsCell")
        styleCell()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension SettingsCell{
    
    private func styleCell(){
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.14
        view.layer.shadowOffset = .zero
        view.layer.shouldRasterize = true
        view.layer.shadowRadius = 10
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.text = "Настройки"
        label.font = .boldSystemFont(ofSize: 20)
        
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        arrowImage.image = UIImage(systemName: "arrow.turn.up.right")
        arrowImage.tintColor = .black
        
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
            arrowImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            arrowImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            arrowImage.widthAnchor.constraint(equalToConstant: 30),
            arrowImage.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
}
