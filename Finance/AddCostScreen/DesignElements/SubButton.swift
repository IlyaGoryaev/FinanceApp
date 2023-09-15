//
//  SubButton.swift
//  Finance
//
//  Created by Илья Горяев on 18.09.2023.
//

import UIKit

final class SubButton: UIButton {
    
    var name: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtonStyle()
    }
    
    init(name: String, frame: CGRect) {
        super.init(frame: frame)
        self.name = name
        setupButtonStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: - Setup style
extension SubButton{
    
    func setupButtonStyle(){
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.lineBreakMode = .byClipping
        self.setTitle(name, for: .normal)
        self.setTitleColor(.gray, for: .normal)
        self.titleLabel?.font = .boldSystemFont(ofSize: 18)
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    }
    
}
