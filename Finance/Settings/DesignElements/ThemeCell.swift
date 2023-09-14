
import UIKit

class ThemeCell: UITableViewCell {
    
    let view = UIView()
    
    let doneView = UIView()
    
    let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "ThemeCell")
        self.selectionStyle = .none
        styleCell()
        setupDoneView()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension ThemeCell{
    
    private func styleCell(){
        self.backgroundColor = UIColor(named: "FinanceBackgroundColor")
        view.backgroundColor = UIColor(named: "FinanaceMainScreenCellColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        
        label.textColor = UIColor(named: "BoldLabelsColor")
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupDoneView(){
            doneView.translatesAutoresizingMaskIntoConstraints = false
            doneView.layer.cornerRadius = 15
            doneView.layer.borderColor = UIColor.black.cgColor
            doneView.layer.borderWidth = 1
        }
    
    private func layout(){
        addSubview(view)
        view.addSubview(label)
        view.addSubview(doneView)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 70),
            view.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            doneView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            doneView.heightAnchor.constraint(equalToConstant: 30),
            doneView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.view.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
    }
    
}
