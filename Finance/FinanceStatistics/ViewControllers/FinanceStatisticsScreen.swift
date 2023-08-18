//
//  FinanceStatisticsScreen.swift
//  Finance
//
//  Created by Илья Горяев on 04.08.2023.
//

import UIKit

class FinanceStatisticsScreen: UIViewController {

    let developLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        developLabel.translatesAutoresizingMaskIntoConstraints = false
        developLabel.text = "В разработке"
        developLabel.font = .boldSystemFont(ofSize: 40)
        developLabel.textColor = .black
        view.addSubview(developLabel)
        NSLayoutConstraint.activate([
            developLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            developLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

    }
}
