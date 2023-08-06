import UIKit
import RxCocoa
import RxSwift
import RxDataSources

protocol FinanceGoalsScreenProtocol: AnyObject{
    func didTapButtonMenu()
}

class FinanceGoalsScreen: UIViewController {

    //MARK: Кнопка бокового меню
    let menuIcon = MenuIcon()
    
    let addButton = UIButton()
    
    let disposeBag = DisposeBag()
    
    private let viewModel = GoalViewModel()
    
    lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: 350, height: 250)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = 30
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(GoalCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = #colorLiteral(red: 0.1716541946, green: 0.1766330898, blue: 0.1461265981, alpha: 1)
        return collectionView
    }()

    weak var delegate: FinanceGoalsScreenProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchGoals()
        setMenuButton()
        setUpCollectionView()
        bindCollectionView()
        setupAddButton()
    }
    
    
    @objc func tappedMenuButton(){
        self.delegate?.didTapButtonMenu()
    }
    
    @objc func tappedAddButton(){
        let controller = AddGoalViewController()
        controller.view.backgroundColor = .white
        self.present(controller, animated: true)
    }
    

}
extension FinanceGoalsScreen: UIScrollViewDelegate{
    private func setMenuButton(){
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
    }
    
    func setUpCollectionView(){
        //MARK: Настройка CollectionView
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60)
        ])
    }
    
    private func bindCollectionView(){
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, GoalObject>> { _, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GoalCell
            cell.nameLabel.text = item.costId
            cell.image.text = item.picture
            cell.sumLableStatus.text = "\(item.currentSum)/\(item.goalSum)"
            cell.backgroundColor = .white
            cell.layer.addSublayer(CircleCategories(circleValue: 50).configureLayer(degreesInPath: 360, x: 350 / 2, y: 250 / 2))
            cell.layer.addSublayer(CircleCategories(circleValue: 50).configureFillLayer(degreesInPath: Int(360 * (Double(item.currentSum) / Double(item.goalSum))), x: 350 / 2, y: 250 / 2, color: .blue, lineWidth: 10))
            return cell
        }
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.items.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }
    
    private func setupAddButton(){
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = .boldSystemFont(ofSize: 30)
        addButton.setTitleColor(.gray, for: .normal)
        addButton.layer.cornerRadius = 25
        addButton.backgroundColor = .white
        addButton.layer.shadowOpacity = 0.4
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        addButton.addTarget(self, action: #selector(tappedAddButton), for: .touchUpInside)
    }
}
