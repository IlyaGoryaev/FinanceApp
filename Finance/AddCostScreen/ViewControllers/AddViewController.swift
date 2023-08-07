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
        //scrollView.frame = view.bounds
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
        view.backgroundColor = .systemGray6
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 82)
        ])
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
        view.addSubview(exitButton)
        exitButton.layer.cornerRadius = 25
        exitButton.layer.shadowOpacity = 0.4
        exitButton.setTitle("✕", for: .normal)
        exitButton.titleLabel?.font = .systemFont(ofSize: 30)
        exitButton.setTitleColor(.gray, for: .normal)
        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: 50),
            exitButton.heightAnchor.constraint(equalToConstant: 50),
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16)
        ])
        exitButton.addAction(UIAction(handler: { _ in
            self.dismiss(animated: true)
        }), for: .touchUpInside)
    }
    
    
    private func setupViewConstraints(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
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
            
            
            let selectedIndex = try! self.viewModel.selectedItem.value()["Category"]
            
            if selectedIndex == nil{
                
                if try! self.viewModel.goalsShow.value() == true{
                    
                    self.collectionViewCategory.cellForItem(at: $0.element!)?.backgroundColor = .red
                    self.animateVisabilityGoals()
                    
                    self.viewModel.isItemSelected.on(.next(true))
                    self.viewModel.isNotGoalsShow()
                    self.viewModel.selectedItem.on(.next(["Category": "\(($0.element!.row))"]))
                    
                    
                } else {
                    
                    
                    self.viewModel.isItemSelected.on(.next(false))
                    self.collectionViewCategory.cellForItem(at: $0.element!)?.backgroundColor = .white
                    self.animateVisabilityGoals()
                    self.viewModel.isGoalsShow()
                    
                }
                
                
            } else {
                
                self.collectionViewCategory.cellForItem(at: $0.element!)?.backgroundColor = .red
                if Int(selectedIndex!)! == $0.element!.row{
                    
                    print("Yes")
                    self.collectionViewCategory.cellForItem(at: $0.element!)?.backgroundColor = .white
                    self.animateVisabilityGoals()
                    self.viewModel.isItemSelected.on(.next(false))
                    self.viewModel.isGoalsShow()
                    
                }
                self.viewModel.selectedItem.on(.next(["Category": "\(($0.element!.row))"]))
            }
            
            if try! self.viewModel.isItemSelected.value() == false{
                self.viewModel.selectedItem.on(.next(["":""]))
            }
        }.disposed(by: disposeBag)
        
        collectionViewCategory.rx.itemDeselected.subscribe {
            self.collectionViewCategory.cellForItem(at: $0)?.backgroundColor = .white
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
            
            let selectedIndex = try! self.viewModel.selectedItem.value()["Goal"]
            
            if selectedIndex == nil{
                
                
                if try! self.viewModel.categoryShow.value() == true{
                    
                    self.collectionViewGoals.cellForItem(at: $0.element!)?.backgroundColor = .red
                    self.animateVisabilityCategories()
                    
                    self.viewModel.isItemSelected.on(.next(true))
                    self.viewModel.isNotCategoriesShow()
                    self.viewModel.selectedItem.on(.next(["Goal": "\(($0.element!.row))"]))
    
                    
                } else {
                    
                    self.viewModel.isItemSelected.on(.next(false))
                    self.collectionViewGoals.cellForItem(at: $0.element!)?.backgroundColor = .white
                    self.animateVisabilityCategories()
                    self.viewModel.isCategoriesShow()
                }
            
            } else {
                
                self.collectionViewGoals.cellForItem(at: $0.element!)?.backgroundColor = .red
                
                if Int(selectedIndex!)! == $0.element!.row{
                    
                    print("Yes")
                    self.collectionViewGoals.cellForItem(at: $0.element!)?.backgroundColor = .white
                    self.animateVisabilityCategories()
                    self.viewModel.isItemSelected.on(.next(false))
                    self.viewModel.isCategoriesShow()
                    
                }
                
                self.viewModel.selectedItem.on(.next(["Goal": "\(($0.element!.row))"]))
                
            }
            
            if try! self.viewModel.isItemSelected.value() == false{
                self.viewModel.selectedItem.on(.next(["":""]))
            }
            
            
            
        }.disposed(by: disposeBag)
        
        collectionViewGoals.rx.itemDeselected.subscribe {
            
            self.collectionViewGoals.cellForItem(at: $0)?.backgroundColor = .white
            
        }.disposed(by: disposeBag)
        
        
        viewModel.goals.bind(to: collectionViewGoals.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        collectionViewGoals.rx.setDelegate(self).disposed(by: disposeBag)
    }

    
}
extension AddCostController{
    
    
    func animateVisabilityGoals(){
        let duration1 = 0.3
        let duration2 = 0.1
        let animatables = [collectionViewGoals, labelGoals]
        _ = animatables.map({ $0.alpha = 0 })
        
        
        let firstAnimation = UIViewPropertyAnimator(duration: duration1, curve: .easeInOut){ [self] in
            _ = animatables.map({ $0.isHidden = try! self.viewModel.goalsShow.value()
            })
        }
        
        firstAnimation.addCompletion { position in
            if position == .end{
                let secondAnimation = UIViewPropertyAnimator(duration: duration2, curve: .easeInOut){
                    _ = animatables.map({ $0.alpha = 1
                    })
                }
                secondAnimation.startAnimation()
            }
        }
        firstAnimation.startAnimation()
    }
    
    
    
    func animateVisabilityCategories(){
        let duration1 = 0.3
        let duration2 = 0.1
        let animatables = [collectionViewCategory, labelCategory]
        _ = animatables.map({ $0.alpha = 0 })
        
        let firstAnimation = UIViewPropertyAnimator(duration: duration1, curve: .easeInOut){ [self] in
            _ = animatables.map({ $0.isHidden = try! self.viewModel.categoryShow.value()
            })
        }
        
        firstAnimation.addCompletion { position in
            if position == .end{
                let secondAnimation = UIViewPropertyAnimator(duration: duration2, curve: .easeInOut){
                    _ = animatables.map({ $0.alpha = 1 })
                }
                secondAnimation.startAnimation()
            }
            
        }
        firstAnimation.startAnimation()
    }
}
