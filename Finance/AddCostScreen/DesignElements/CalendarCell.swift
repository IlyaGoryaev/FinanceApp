//
//  CalendarCell.swift
//  Finance
//
//  Created by Илья Горяев on 19.09.2023.
//

import UIKit

final class CalendarCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: - Setup style and layout
private extension CalendarCell{
    
    func setupView(){
        imageView.image = UIImage(named: "Calendar")
        self.layer.cornerRadius = 10
        self.label.font = .boldSystemFont(ofSize: 20)
    }
    
    func setupLayout(){
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
}
//MARK: - Setup selection style
extension CalendarCell{
    
    func setupSelectedStyle(){
        imageView.isHidden = true
        self.backgroundColor = #colorLiteral(red: 0.985034883, green: 0.8090179563, blue: 0.7341457605, alpha: 1)
    }
    
    func setupUnSelectedStyle(){
        imageView.isHidden = false
        self.backgroundColor = UIColor(named: "FinanaceMainScreenCellColor")
    }
    
}
