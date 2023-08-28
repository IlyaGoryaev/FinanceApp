import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class IncomeScreen: UIViewController, UIScrollViewDelegate {
    
    //MARK: Кнопка бокового меню
    let menuIcon = MenuIcon.build(color: .brown, frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    let addButton = UIButton()
    
    //MARK: Круговая диаграмма трат
    let viewWithCircleContainer = UIView()
    let label = UILabel()
    let subLabel = UILabel()
    
    //MARK: Labels
    let categoryLabel = UILabel()
    let noIncomes = UILabel()
    
    lazy var collectionViewCategoriesPercantage: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: view.frame.width * 0.42, height: view.frame.height * 0.18)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(CellForIncomeScreen.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(ExtraIncomeCell.self, forCellWithReuseIdentifier: "ExtraCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var arrayOfCategoriesSection = [IncomeCategories.RawValue: Double]()
    
    let disposeBag = DisposeBag()
    
    
    
    //MARK: Кнопки периода
    let buttons = Buttons()
    
    //MARK: Инициализация viewModel
    private var viewModel = IncomeScreenViewModel()
    
    //MARK: ScrollView
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = contentSize
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    //MARK: Контейнер для ScrollView
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.frame.size = contentSize
        return contentView
    }()
    
    //MARK: Размер scrollView
    private var contentSize: CGSize {
        let goalsService = GoalsService()
        let objects = goalsService.getAllGoalModels()
        if objects.isEmpty {
            return CGSize(width: view.frame.width, height: view.frame.height)
        } else {
            return CGSize(width: view.frame.width, height: view.frame.height + 100)
        }
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        let chosen = try! self.viewModel.categoryChosen.value()
        switch chosen{
        case 1:
            setupDay()
            break
        case 2:
            setupMonth()
            break
        case 3:
            setupYear()
            break
        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        
        //setupMenuButton()
        
        //MARK: Настройка кнопок периода
        setUpButtons()
        
        
        setupLabel()
        stackView.addArrangedSubview(buttons)
        
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        addButton.titleLabel?.font = .boldSystemFont(ofSize: 30)
        addButton.tintColor = .gray
        viewWithCircleContainer.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: viewWithCircleContainer.trailingAnchor, constant: 16),
            addButton.bottomAnchor.constraint(equalTo: viewWithCircleContainer.bottomAnchor, constant: 16),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        addButton.backgroundColor = .white
        addButton.layer.cornerRadius = 25
        addButton.layer.shadowOpacity = 0.15
        addButton.layer.shadowOffset = .zero
        addButton.layer.shouldRasterize = true
        addButton.layer.shadowRadius = 10
        addButton.addTarget(self, action: #selector(addMenu), for: .touchUpInside)
        
        
        viewModel.percentArray.subscribe {
            self.arrayOfCategoriesSection = $0
        }.disposed(by: disposeBag)
    
        stackView.addArrangedSubview(viewWithCircleContainer)
        NSLayoutConstraint.activate([
            viewWithCircleContainer.heightAnchor.constraint(equalToConstant: view.frame.width * 0.76),
            viewWithCircleContainer.widthAnchor.constraint(equalToConstant: view.frame.width * 0.76)

        ])
        viewWithCircleContainer.backgroundColor = .white
        
        noIncomes.text = "За данный период нет доходов"
        noIncomes.textColor = .gray
        noIncomes.font = .boldSystemFont(ofSize: 20)
        stackView.addArrangedSubview(noIncomes)
        
        bindCollectionView()
        setupCollectionView()
        
        viewModel.categories.subscribe {
            let boolValue = $0[0].items.isEmpty
            self.collectionViewCategoriesPercantage.isHidden = boolValue
            self.categoryLabel.isHidden = boolValue
            self.label.isHidden = boolValue
            self.subLabel.isHidden = boolValue
        }.disposed(by: disposeBag)
        self.viewModel.extraValue.on(.next(try! self.viewModel.extraValueDay.value()))

    }
    
    
    @objc func addMenu(){
        let controller = IncomeViewController()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK: Настройка компонентов внутри круговой диаграммы
    func setupLabel(){
        viewModel.labelText.subscribe{
            self.label.text = $0
        }.disposed(by: disposeBag)
        viewModel.subLabelText.subscribe {
            self.subLabel.text = $0
        }.disposed(by: disposeBag)
        label.font = .boldSystemFont(ofSize: 40)//Исправить под значение
        subLabel.font = .systemFont(ofSize: 20)
        label.textColor = .black
        subLabel.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        viewWithCircleContainer.addSubview(label)
        viewWithCircleContainer.addSubview(subLabel)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: viewWithCircleContainer.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: viewWithCircleContainer.centerYAnchor, constant: 10),
            subLabel.centerXAnchor.constraint(equalTo: viewWithCircleContainer.centerXAnchor),
            subLabel.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -5)
        ])
    }
    
    private func setupViewConstraints(){
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    //MARK: Настройка кнопок
    func setUpButtons(){
        buttons.buttonDay.titleLabel?.font = .boldSystemFont(ofSize: self.view.frame.width * 0.09)
        buttons.buttonMonth.titleLabel?.font = .boldSystemFont(ofSize: self.view.frame.width * 0.09)
        buttons.buttonYear.titleLabel?.font = .boldSystemFont(ofSize: self.view.frame.width * 0.09)
        buttons.buttonDay.addAction(UIAction(handler: { _ in
            self.buttons.buttonDay.setTitleColor(.black, for: .normal)
            self.buttons.buttonMonth.setTitleColor(.systemGray2, for: .normal)
            self.buttons.buttonYear.setTitleColor(.systemGray2, for: .normal)
            self.setupDay()
        }), for:  .touchUpInside)
        
        buttons.buttonMonth.addAction(UIAction(handler: { _ in
            self.buttons.buttonDay.setTitleColor(.systemGray2, for: .normal)
            self.buttons.buttonMonth.setTitleColor(.black, for: .normal)
            self.buttons.buttonYear.setTitleColor(.systemGray2, for: .normal)
            self.setupMonth()
        }), for: .touchUpInside)
        
        buttons.buttonYear.addAction(UIAction(handler: { _ in
            self.buttons.buttonDay.setTitleColor(.systemGray2, for: .normal)
            self.buttons.buttonMonth.setTitleColor(.systemGray2, for: .normal)
            self.buttons.buttonYear.setTitleColor(.black, for: .normal)
            self.setupYear()
        }), for: .touchUpInside)
    }
}
extension IncomeScreen{
    func setupCollectionView(){
        categoryLabel.text = "Категории доходов"
        categoryLabel.textColor = .gray
        categoryLabel.font = .systemFont(ofSize: 20)
        stackView.addArrangedSubview(categoryLabel)
        
        stackView.addArrangedSubview(collectionViewCategoriesPercantage)
        stackView.setCustomSpacing(40, after: viewWithCircleContainer)
        collectionViewCategoriesPercantage.backgroundColor = .white
        NSLayoutConstraint.activate([
            collectionViewCategoriesPercantage.heightAnchor.constraint(equalToConstant: view.frame.height * 0.26),
            collectionViewCategoriesPercantage.widthAnchor.constraint(equalToConstant: view.frame.width)
        
        ])
        stackView.setCustomSpacing(0, after: categoryLabel)
    }
    
    
    func bindCollectionView(){
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, IncomeCategoryModel>> { _, collectionView, indexPath, item in
            let indexOfLast = try! self.viewModel.categories.value()[0].items.count - 1
            let boolValue = try! self.viewModel.extraValue.value()
            if indexPath.row == indexOfLast && boolValue{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExtraCell", for: indexPath) as! ExtraIncomeCell
                cell.percentLabel.text = "\(item.percents)%"
                cell.layer.shadowColor = UIColor.lightGray.cgColor
                cell.layer.shadowOpacity = 0.25
                cell.layer.shadowOffset = .zero
                cell.layer.shadowRadius = 20
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CellForIncomeScreen
                cell.categoryLabel.text = CategoryIncomeDesignElements().getRussianLabelText()[item.category.rawValue]
                cell.sumLabel.text = "\(item.incomeSum)"
                cell.percentLabel.text = "\(item.percents)%"
                cell.colorImage.backgroundColor = item.color
                cell.backgroundColor = .white
                cell.layer.shadowColor = UIColor.lightGray.cgColor
                cell.layer.shadowOpacity = 0.25
                cell.layer.shadowOffset = .zero
                cell.layer.shadowRadius = 20
                return cell
            }
        }
        
        viewModel.categories.bind(to: collectionViewCategoriesPercantage.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        collectionViewCategoriesPercantage.rx.setDelegate(self).disposed(by: disposeBag)
        
        collectionViewCategoriesPercantage.rx.itemSelected.subscribe {
            let cell = self.collectionViewCategoriesPercantage.dequeueReusableCell(withReuseIdentifier: "Cell", for: $0) as! CellForIncomeScreen
            print("Название ячейки: \(cell.categoryLabel.text)")
            self.showCalendarViewControllerInACustomizedSheet(category: "auto")
        }.disposed(by: disposeBag)
        
    }
    
    func showCalendarViewControllerInACustomizedSheet(category: String) {
        let viewControllerToPresent = ListSortedCostsViewController(category: category, nibName: nil, bundle: nil)
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(viewControllerToPresent, animated: true)
    }
    
    func setupDay(){
        self.viewModel.getDayStatistics()
        self.viewModel.getDayLabelText()
        self.viewModel.getCircleDay()
        if label.text != "0"{
            noIncomes.isHidden = true
        } else {
            noIncomes.isHidden = false
        }
        self.viewWithCircleContainer.layer.sublayers?.forEach({
            $0.isHidden = true
        })
        self.addButton.isHidden = false
        self.label.isHidden = false
        self.subLabel.isHidden = false
        for layer in CircleCategories(circleValue: Int(self.view.frame.width * 0.76) / 2).getCategoriesIncomeLayer(percentDict: self.arrayOfCategoriesSection){
            self.viewWithCircleContainer.layer.addSublayer(layer)
        }
        self.viewModel.extraValue.on(.next(try! self.viewModel.extraValueDay.value()))
        self.viewModel.categoryChosen.on(.next(1))
    }
    
    func setupMonth(){
        self.viewModel.getMonthStatistics()
        self.viewModel.getMonthLabelText()
        self.viewModel.getCircleMonth()
        if label.text != "0"{
            noIncomes.isHidden = true
        } else {
            noIncomes.isHidden = false
        }
        self.viewWithCircleContainer.layer.sublayers?.forEach({
            $0.isHidden = true
        })
        self.addButton.isHidden = false
        self.label.isHidden = false
        self.subLabel.isHidden = false
        for layer in CircleCategories(circleValue: Int(self.view.frame.width * 0.76) / 2).getCategoriesIncomeLayer(percentDict: self.arrayOfCategoriesSection){
            self.viewWithCircleContainer.layer.addSublayer(layer)
        }
        self.viewModel.extraValue.on(.next(try! self.viewModel.extraValueMonth.value()))
        self.viewModel.categoryChosen.on(.next(2))
    }
    
    func setupYear(){
        self.viewModel.getYearStatistics()
        self.viewModel.getYearLabelText()
        self.viewModel.getCircleYear()
        if label.text != "0"{
            noIncomes.isHidden = true
        } else {
            noIncomes.isHidden = false
        }
        self.viewWithCircleContainer.layer.sublayers?.forEach({
            $0.isHidden = true
        })
        self.addButton.isHidden = false
        self.label.isHidden = false
        self.subLabel.isHidden = false
        for layer in CircleCategories(circleValue: Int(self.view.frame.width * 0.76) / 2).getCategoriesIncomeLayer(percentDict: self.arrayOfCategoriesSection){
            self.viewWithCircleContainer.layer.addSublayer(layer)
        }
        self.viewModel.extraValue.on(.next(try! self.viewModel.extraValueYear.value()))
        self.viewModel.categoryChosen.on(.next(3))
    }
}
