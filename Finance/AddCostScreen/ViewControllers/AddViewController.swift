import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class AddCostController: UIViewController, UIScrollViewDelegate {
    //MARK: Кнопки наверху контроллера
    let exitButton = UIButton()

    //MARK: Графические элементы
    let labelCategory = UILabel()
    let labelGoals = UILabel()
    let dateView = UIView()
    let dateStackView = UIStackView()
    let calendarButton = UIButton()
    
    
    let disposeBag = DisposeBag()
    let viewModel = AddCostViewModel()

    
    //MARK: Инициализация текстового поля
    let textField = UITextField()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemGray6
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    
    //MARK: Контейнер для ScrollView
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .systemGray6
        contentView.frame.size = contentSize
        return contentView
    }()
    
    
    //MARK: StackView в котором располагаются элементы
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    
    //MARK: collectionView для выбора категории, инициализация
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
    
    
    //MARK: collectionView для выбора цели, инициализация
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
    
    
    //MARK: collectionView для выбора даты, инициализация
    lazy var dateCollectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: 60, height: 60)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    
    //MARK: Размер контента внутри scrollView
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height)
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
        
        bindCollectionViewCategory()
        
        viewModel.fetchGoalObjects()
        if try! viewModel.goals.value() != []{
            setupCollectionViewGoals()
            bindCollectionViewGoals()
        }
        setupDateStackView()
        
    }
    
    
}
extension AddCostController{
    
    private func setupDateStackView(){
        setupDateCollectionView()
        viewModel.fetchDates()
        bindDateCollectionView()
        setupDateButton()
        
        dateStackView.axis = .horizontal
        dateStackView.distribution = .equalCentering
        
        [self.dateCollectionView, self.calendarButton].forEach {
            dateStackView.addArrangedSubview($0)
        }
        
        stackView.addArrangedSubview(dateStackView)
        
        self.viewModel.isItemSelected.subscribe {
            self.dateStackView.isHidden = !$0.element!
        }.disposed(by: disposeBag)
        dateCollectionView.cellForItem(at: IndexPath(item: 2, section: 0))?.isSelected = true
    }
    
    private func setupDateButton(){
        
        calendarButton.setTitle("🗓️", for: .normal)
        calendarButton.layer.cornerRadius = 30
        calendarButton.titleLabel?.font = .systemFont(ofSize: 40)
        calendarButton.backgroundColor = .systemGray5
        calendarButton.layer.borderColor = UIColor.systemGray2.cgColor
        calendarButton.layer.borderWidth = 1
        calendarButton.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            calendarButton.widthAnchor.constraint(equalToConstant: 60),
            calendarButton.heightAnchor.constraint(equalToConstant: 60)
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
    }
    
    
    private func setupTextFiled(){
        stackView.addArrangedSubview(textField)
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.placeholder = "1000₽"
        textField.textAlignment = .right
        textField.font = .systemFont(ofSize: 30)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(equalToConstant: view.frame.width - 16),
            textField.heightAnchor.constraint(equalToConstant: 50)
        ])
        textField.rx.text.subscribe {
            if let sumInt = Int($0.element!!){
                self.viewModel.sum.on(.next(sumInt))
                self.viewModel.buttonStatus()
            } else {
                self.viewModel.sum.on(.next(0))
                self.viewModel.buttonStatus()
            }
        }.disposed(by: disposeBag)
        self.viewModel.sum.subscribe {
            print($0)
        }.disposed(by: disposeBag)
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
