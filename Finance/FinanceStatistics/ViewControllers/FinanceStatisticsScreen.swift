//
//  FinanceStatisticsScreen.swift
//  Finance
//
//  Created by Илья Горяев on 04.08.2023.
//

import UIKit

class FinanceStatisticsScreen: UIViewController {
    
    let statisticsView = UIView()
    let menuStatisticsView = MenuStatisticsView()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .systemBackground
        contentView.frame.size = contentSize
        return contentView
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        setupViewConstraints()
        setupStatisticsView()
        setupMenuStatisticsView()
    }
}
extension FinanceStatisticsScreen{
    
    private func setupViewConstraints(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
}
extension FinanceStatisticsScreen{
    
    private func setupStatisticsView(){
        statisticsView.translatesAutoresizingMaskIntoConstraints = false
        statisticsView.backgroundColor = .red
        stackView.addArrangedSubview(statisticsView)
        NSLayoutConstraint.activate([
            statisticsView.heightAnchor.constraint(equalToConstant: 400),
            statisticsView.widthAnchor.constraint(equalToConstant: view.frame.width - 50)
        ])
    }
    
    private func setupMenuStatisticsView(){
        
        menuStatisticsView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(menuStatisticsView)
        NSLayoutConstraint.activate([
            menuStatisticsView.heightAnchor.constraint(equalToConstant: 200),
            menuStatisticsView.widthAnchor.constraint(equalToConstant: view.frame.width - 40)
        
        ])
    }
    
}
