import UIKit

class CostCell: UITableViewCell {
    
    let view = UIView()
    let label1 = UILabel()
    let label2 = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "CostCell")
        setupStyle()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CostCell{
    
    func setupStyle(){
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout(){
        addSubview(view)
        addSubview(label1)
        addSubview(label2)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 60),
            view.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            label1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            label1.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            label2.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
}
