import UIKit

class AddCostGoalCell: UICollectionViewCell {
    
    let pictureLabel = UILabel()
    let greenView = UIView()
    let labelSelected = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addDashedBorder()
        pictureLabel.translatesAutoresizingMaskIntoConstraints = false
        greenView.translatesAutoresizingMaskIntoConstraints = false
        labelSelected.translatesAutoresizingMaskIntoConstraints = false
        greenView.backgroundColor = .green
        greenView.layer.cornerRadius = 15
        labelSelected.text = "✔️"
        labelSelected.textColor = .white
        addSubview(pictureLabel)
        addSubview(greenView)
        addSubview(labelSelected)
        NSLayoutConstraint.activate([
            pictureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            pictureLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            greenView.centerXAnchor.constraint(equalTo: centerXAnchor),
            greenView.centerYAnchor.constraint(equalTo: centerYAnchor),
            greenView.widthAnchor.constraint(equalToConstant: 30),
            greenView.heightAnchor.constraint(equalToConstant: 30),
            labelSelected.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelSelected.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        greenView.isHidden = true
        labelSelected.isHidden = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
extension AddCostGoalCell{
    func addDashedBorder() {
        let lineWidth: CGFloat = 2.0
        let circularPath = UIBezierPath.init(ovalIn: CGRect(x: 0, y: 0, width: 60, height: 60))
        
        // add a new layer for the white border
        let borderLayer = CAShapeLayer()
        borderLayer.path = circularPath.cgPath
        borderLayer.lineWidth = lineWidth
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.fillColor = nil
        borderLayer.lineDashPattern = [6, 3]
        self.layer.addSublayer(borderLayer)
        
        // set the circle mask to your profile image view
        let circularMask = CAShapeLayer()
        circularMask.path = circularPath.cgPath
        self.layer.mask = circularMask
        
    }
}
