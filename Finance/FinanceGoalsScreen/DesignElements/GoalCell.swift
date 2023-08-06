//
//  GoalCell.swift
//  Finance
//
//  Created by Илья Горяев on 06.08.2023.
//

import UIKit

class GoalCell: UICollectionViewCell {
    
    let nameLabel = UILabel()
    let sumLableStatus = UILabel()
    let image = UILabel()
    let imageBackground = UIImageView()
    let frontView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageBackground.image = UIImage(named: "See")
        imageBackground.translatesAutoresizingMaskIntoConstraints = false
        imageBackground.layer.cornerRadius = 10
        imageBackground.contentMode = .scaleToFill
        addSubview(imageBackground)
        NSLayoutConstraint.activate([
            imageBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageBackground.topAnchor.constraint(equalTo: topAnchor),
            imageBackground.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageBackground.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurredEffectView)
        NSLayoutConstraint.activate([
            blurredEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurredEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurredEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurredEffectView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        
        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 0.4
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Название"
        nameLabel.font = .boldSystemFont(ofSize: 25)
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        sumLableStatus.translatesAutoresizingMaskIntoConstraints = false
        sumLableStatus.text = "0/1000000"
        sumLableStatus.font = .systemFont(ofSize: 20)
        addSubview(sumLableStatus)
        NSLayoutConstraint.activate([
            sumLableStatus.centerXAnchor.constraint(equalTo: centerXAnchor),
            sumLableStatus.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        
        ])
        image.translatesAutoresizingMaskIntoConstraints = false
        image.text = "🏖️"
        image.font = .systemFont(ofSize: 45)
        addSubview(image)
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.centerYAnchor.constraint(equalTo: centerYAnchor)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
