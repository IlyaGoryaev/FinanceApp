import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class AddCostController: UIViewController, UIScrollViewDelegate {
    
    let exitButton = UIButton()

    let labelCategory = UILabel()
    
    let labelGoals = UILabel()
        
    let disposeBag = DisposeBag()
    
    let viewModel = AddCostViewModel()

    let textField = UITextField()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemGray6
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .systemGray6
        contentView.frame.size = contentSize
        return contentView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    lazy var collectionViewCategory: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: 60, height: 60)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionViewFlowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    lazy var collectionViewGoals: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: 60, height: 60)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(AddCostGoalCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 500)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        setupTextFiled()
        setupViewConstraints()
        setupExitButton()
        setupCollectionViewCategory()
        setupCollectionViewGoals()
        bindCollectionViewCategory()
        bindCollectionViewGoals()
        viewModel.fetchGoalObjects()
    }
    
    
}
extension AddCostController{
    
    private func setupCollectionViewGoals(){
        labelGoals.text = "Цели"
        labelGoals.textColor = .gray
        collectionViewGoals.backgroundColor = .white
        collectionViewGoals.layer.cornerRadius = 10
        stackView.addArrangedSubview(labelGoals)
        stackView.addArrangedSubview(collectionViewGoals)
        NSLayoutConstraint.activate([
            collectionViewGoals.widthAnchor.constraint(equalToConstant: view.frame.width - 16),
            collectionViewGoals.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    
    private func setupCollectionViewCategory(){
        labelCategory.text = "Категории"
        labelCategory.textColor = .gray
        collectionViewCategory.backgroundColor = .white
        collectionViewCategory.layer.cornerRadius = 10
        stackView.addArrangedSubview(labelCategory)
        stackView.addArrangedSubview(collectionViewCategory)
        NSLayoutConstraint.activate([
            collectionViewCategory.widthAnchor.constraint(equalToConstant: view.frame.width - 16),
            collectionViewCategory.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    
    private func setupExitButton(){
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.backgroundColor = .white
        contentView.addSubview(exitButton)
        exitButton.layer.cornerRadius = 25
        exitButton.layer.shadowOpacity = 0.4
        exitButton.setTitle("✕", for: .normal)
        exitButton.titleLabel?.font = .systemFont(ofSize: 30)
        exitButton.setTitleColor(.gray, for: .normal)
        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: 50),
            exitButton.heightAnchor.constraint(equalToConstant: 50),
            exitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            exitButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ])
        exitButton.addAction(UIAction(handler: { _ in
            self.dismiss(animated: true)
        }), for: .touchUpInside)
    }
    
    
    private func setupViewConstraints(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 82),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        for view in stackView.arrangedSubviews{
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: 300),
                view.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
    }
    
    
    private func setupTextFiled(){
        stackView.addArrangedSubview(textField)
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.placeholder = "1000₽"
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(equalToConstant: 300),
            textField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    private func bindCollectionViewCategory(){

        let data = Observable.just(CategoryCostsDesignElements().getCategoryEmoji().values)

        data.bind(to: collectionViewCategory.rx.items){collectionView, index, item in
            let indexPath = IndexPath(item: index, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCell
            cell.label.text = item
            cell.label.font = .systemFont(ofSize: 40)
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 30
            return cell
        }.disposed(by: disposeBag)
        
        collectionViewCategory.rx.itemSelected.subscribe {
            if try! self.viewModel.goalsShow.value() == true{
                self.viewModel.isNotGoalsShow()
                self.collectionViewCategory.cellForItem(at: $0)?.backgroundColor = .red
                self.collectionViewGoals.isHidden = true
                self.labelGoals.isHidden = true
            } else {
                self.viewModel.isGoalsShow()
                self.collectionViewCategory.cellForItem(at: $0)?.backgroundColor = .white
                self.collectionViewGoals.isHidden = false
                self.labelGoals.isHidden = false
            }
        }.disposed(by: disposeBag)

        collectionViewCategory.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    
    
    private func bindCollectionViewGoals(){
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, GoalObject>> { _, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AddCostGoalCell
            cell.pictureLabel.text = item.picture
            cell.layer.cornerRadius = 30
            cell.pictureLabel.font = .systemFont(ofSize: 40)
            return cell
        }
        collectionViewGoals.rx.itemSelected.subscribe {
            if try! self.viewModel.categoryShow.value() == true{
                self.viewModel.isNotCategoriesShow()
                self.collectionViewGoals.cellForItem(at: $0)?.backgroundColor = .red
                self.collectionViewCategory.isHidden = true
                self.labelCategory.isHidden = true
            } else {
                self.viewModel.isCategoriesShow()
                self.collectionViewGoals.cellForItem(at: $0)?.backgroundColor = .white
                self.collectionViewCategory.isHidden = false
                self.labelCategory.isHidden = false
            }
        }.disposed(by: disposeBag)
        
        
        viewModel.goals.bind(to: collectionViewGoals.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        collectionViewGoals.rx.setDelegate(self).disposed(by: disposeBag)
    }

    
}
