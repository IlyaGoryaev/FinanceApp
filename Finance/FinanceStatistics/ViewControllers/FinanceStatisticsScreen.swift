//
//  FinanceStatisticsScreen.swift
//  Finance
//
//  Created by Илья Горяев on 04.08.2023.
//

import UIKit

protocol FinanceStatisticsScreenProtocol: AnyObject{
    func didTapButtonMenu()
}

class FinanceStatisticsScreen: UIViewController {

    //MARK: Кнопка бокового меню
    let menuIcon = MenuIcon()
    let developLabel = UILabel()

    weak var delegate: FinanceStatisticsScreenProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Настройка кнопки меню
        menuIcon.translatesAutoresizingMaskIntoConstraints = false
        menuIcon.backgroundColor = .white
        view.addSubview(menuIcon)
        NSLayoutConstraint.activate([
            menuIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            menuIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuIcon.heightAnchor.constraint(equalToConstant: 50),
            menuIcon.widthAnchor.constraint(equalToConstant: 50)
        ])
        let tapMenuIconGesture = UITapGestureRecognizer(target: self, action: #selector(tappedMenuButton))
        menuIcon.addGestureRecognizer(tapMenuIconGesture)
        
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
    @objc func tappedMenuButton(){
        self.delegate?.didTapButtonMenu()
    }

}
