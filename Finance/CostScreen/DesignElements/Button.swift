//
//  Button.swift
//  Finance
//
//  Created by Илья Горяев on 25.07.2023.
//

import UIKit

class Button: UIButton {
    
    let label = UILabel()
    var titleLable: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    init(frame: CGRect, titleLabel: String) {
        super.init(frame: frame)
        self.titleLable = titleLabel
        style()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension Button{
    
    func style(){
        setTitle(titleLable, for: .normal)
        setTitleColor(#colorLiteral(red: 0.1716541946, green: 0.1766330898, blue: 0.1461265981, alpha: 1), for: .normal)
        backgroundColor = #colorLiteral(red: 1, green: 0.9999921918, blue: 0.3256074786, alpha: 1)
        layer.cornerRadius = 18
    }
    
    
    
    
}
