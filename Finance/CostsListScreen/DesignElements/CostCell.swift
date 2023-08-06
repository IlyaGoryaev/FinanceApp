import UIKit

class CostCell: UITableViewCell {
    
    let view = UIView()
    let labelCost = UILabel()
    let labelCategory = UILabel()
    let labelComment = UILabel()
    let categoryColorView = UIView()
    let emojiLabel = UILabel()
    let circleView = UIView()
    let stackViewCategory = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "CostCell")
        setUpStackViewCategory()
        setupStyle()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpStackViewCategory(){
        
        labelComment.font = .boldSystemFont(ofSize: 20)
        labelComment.textColor = .black
        labelCategory.font = .italicSystemFont(ofSize: 18)
        labelCategory.textColor = .gray
        
        stackViewCategory.axis = .vertical
        stackViewCategory.alignment = .leading
        stackViewCategory.spacing = 2
        
        [self.labelComment, self.labelCategory].forEach {
            stackViewCategory.addArrangedSubview($0)
        }
        
        
    }
}
extension CostCell{
    
    func setupStyle(){
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        labelCost.translatesAutoresizingMaskIntoConstraints = false
        categoryColorView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        circleView.translatesAutoresizingMaskIntoConstraints = false
        stackViewCategory.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.text = "⚽️"
        emojiLabel.font = .boldSystemFont(ofSize: 40)
        view.layer.cornerRadius = 10
        categoryColorView.layer.cornerRadius = 10
        categoryColorView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        view.layer.shadowOpacity = 0.25
        categoryColorView.layer.shadowOpacity = 0.25
        circleView.backgroundColor = .systemGray6
        circleView.layer.cornerRadius = 35
    }
    
    func layout(){
        addSubview(view)
        addSubview(labelCost)
        addSubview(categoryColorView)
        addSubview(circleView)
        addSubview(stackViewCategory)
        circleView.addSubview(emojiLabel)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 80),
            view.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            labelCost.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            labelCost.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            categoryColorView.heightAnchor.constraint(equalToConstant: 80),
            categoryColorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryColorView.widthAnchor.constraint(equalToConstant: 10),
            categoryColorView.topAnchor.constraint(equalTo: view.topAnchor),
            circleView.heightAnchor.constraint(equalToConstant: 70),
            circleView.widthAnchor.constraint(equalToConstant: 70),
            circleView.leadingAnchor.constraint(equalTo: categoryColorView.trailingAnchor, constant: 10),
            circleView.centerYAnchor.constraint(equalTo: categoryColorView.centerYAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            stackViewCategory.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackViewCategory.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 8)
        ])
        
    }
    
}
