import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import SwiftUI
import RealmSwift

class ViewController: UIViewController, UIScrollViewDelegate {
    
    let topView = UIView()
    let disposeBag = DisposeBag()
    private var modelButtons = ButtonStackViewModel()
    let buttons = ButtonsStackView()
    let categoryStackView = CategoryStackView()
    var costValue = String()
    private var collectionViewModelView = CollectionViewModelView()
    
    lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        let cellSize = CGSize(width: 150, height: 150)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionViewFlowLayout.itemSize = cellSize
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .blue
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelButtons.labelInfo.subscribe {
            self.costValue = $0
        }.disposed(by: disposeBag)
        categoryStackView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        topView.backgroundColor = #colorLiteral(red: 0.1716541946, green: 0.1766330898, blue: 0.1461265981, alpha: 1)
        topView.translatesAutoresizingMaskIntoConstraints = false
        buttons.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(categoryStackView)
        view.addSubview(topView)
        view.addSubview(buttons)
        let vc = UIHostingController(rootView: SwiftUIView(colorBackground: #colorLiteral(red: 0.1716541946, green: 0.1766330898, blue: 0.1461265981, alpha: 1), text: costValue))
        let swiftuiView = vc.view!
        swiftuiView.translatesAutoresizingMaskIntoConstraints = false
        addChild(vc)
        topView.addSubview(swiftuiView)
        NSLayoutConstraint.activate([
            swiftuiView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            swiftuiView.bottomAnchor.constraint(equalTo: categoryStackView.topAnchor)
        ])
        vc.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            categoryStackView.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            categoryStackView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            categoryStackView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
        ])
        NSLayoutConstraint.activate([
            buttons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttons.bottomAnchor.constraint(equalTo: swiftuiView.topAnchor),
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        categoryStackView.costButton.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        setUpButtons()
        setUpCollectionView()
        bindCollectionView()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionViewModelView.fetchSections()
        
    }
    
    @objc func tappedButton(){
        let controller = CostViewController()
        controller.view.backgroundColor = #colorLiteral(red: 0.1716541946, green: 0.1766330898, blue: 0.1461265981, alpha: 1)
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.viewControllers = [controller]
        navigationController.view.backgroundColor = #colorLiteral(red: 0.1716541946, green: 0.1766330898, blue: 0.1461265981, alpha: 1)
        present(navigationController, animated: true)
    }
    
    
    @objc func tappedButtonDay(){
        modelButtons.getInfoByPeriod(during: buttons.buttonDay.titleLable!)
        setUpCircle()
    }
    
    @objc func tappedButtonMonth(){
        modelButtons.getInfoByPeriod(during: buttons.buttonMonth.titleLable!)
        setUpCircle()
    }
    @objc func tappedButtonYear(){
        modelButtons.getInfoByPeriod(during: buttons.buttonYear.titleLable!)
        setUpCircle()
    }
    
    
    
    
    
}
extension ViewController{
    
    func setUpButtons(){
        buttons.buttonDay.addTarget(self, action: #selector(tappedButtonDay), for: .touchUpInside)
        buttons.buttonMonth.addTarget(self, action: #selector(tappedButtonMonth), for: .touchUpInside)
        buttons.buttonYear.addTarget(self, action: #selector(tappedButtonYear), for: .touchUpInside)
    }
    
    func setUpCircle(){
        
        let vc = UIHostingController(rootView: SwiftUIView(colorBackground: #colorLiteral(red: 0.1716541946, green: 0.1766330898, blue: 0.1461265981, alpha: 1), text: costValue))
        let swiftuiView = vc.view!
        swiftuiView.translatesAutoresizingMaskIntoConstraints = false
        addChild(vc)
        topView.addSubview(swiftuiView)
        NSLayoutConstraint.activate([
            swiftuiView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            swiftuiView.bottomAnchor.constraint(equalTo: categoryStackView.topAnchor)
        ])
        vc.didMove(toParent: self)
    }
    
}
extension ViewController{
    
    private func setUpCollectionView(){
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor)
        ])
        
    }
    
    private func bindCollectionView(){
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, CategoryModel>> { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCell
            cell.backgroundColor = .red
            cell.label.text = String(item.usage)
            cell.label.font = UIFont(name: "MochiyPopPOne-Regular", size: 40)
            return cell
        }
        collectionViewModelView.section.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    
}

