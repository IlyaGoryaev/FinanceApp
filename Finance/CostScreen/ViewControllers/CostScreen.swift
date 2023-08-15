import UIKit
import RxSwift
import RxCocoa
import RxDataSources

//Решить проблему с добалением view в стек
//компановка элементов
//Удаление слоев
//Распознавание жестов над слоями
//рефакторинг кода
protocol CostScreenDelegate: AnyObject{
    func didTapButtonMenu()
}

class CostScreen: UIViewController, UIScrollViewDelegate {
    
    //MARK: Кнопка бокового меню
    let menuIcon = MenuIcon.build(color: .brown, frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    let addButton = UIButton()
    
    //MARK: Круговая диаграмма трат
    let viewWithCircleContainer = UIView()
    let label = UILabel()
    let subLabel = UILabel()
    
    //MARK: Labels
    let categoryLabel = UILabel()
    
    let searchImage = UIImageView()
    
    //MARK: Состояния вида, которые расширяется и скалдывается
    enum CardState{
        case expand
        case collapsed
    }
    
    lazy var collectionViewCategoriesPercantage: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: 164, height: 150)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(CellForCostScreen.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(ExtraCell.self, forCellWithReuseIdentifier: "ExtraCell")

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    var arrayOfCategoriesSection = [Categories.RawValue: Double]()
    
    let disposeBag = DisposeBag()
    
    
    weak var delegate: CostScreenDelegate?
    
    //MARK: Кнопки периода
    let buttons = Buttons()
    
    //MARK: Инициализация viewModel
    private var viewModel = CostScreenViewModel()
    
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
    
    
    
    var height = UIApplication.shared.delegate?.window?!.windowScene?.keyWindow?.frame.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)
        ])
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        setupViewConstraints()
        
        //MARK: Настройка кнопки меню
        menuIcon.translatesAutoresizingMaskIntoConstraints = false
        menuIcon.backgroundColor = .white
        view.addSubview(menuIcon)
        NSLayoutConstraint.activate([
            menuIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            menuIcon.topAnchor.constraint(equalTo: view.topAnchor,  constant: 45),
            menuIcon.heightAnchor.constraint(equalToConstant: 34),
            menuIcon.widthAnchor.constraint(equalToConstant: 34)
        ])
        let tapMenuIconGesture = UITapGestureRecognizer(target: self, action: #selector(tappedMenuButton))
        menuIcon.addGestureRecognizer(tapMenuIconGesture)
        
        //MARK: Настройка кнопок периода
        setUpButtons()
        
        
        setupLabel()
        stackView.addArrangedSubview(buttons)
        viewModel.getCircleDay()
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = .boldSystemFont(ofSize: 30)
        addButton.setTitleColor(.gray, for: .normal)
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
        
        
        
        //MARK: Добавление слоев круговой диаграммы
        for layer in CircleCategories(circleValue: Int(view.frame.width * 0.76) / 2).getCategoriesLayer(percentDict: arrayOfCategoriesSection){
            viewWithCircleContainer.layer.addSublayer(layer)
            print(layer)
        }
        
        
        bindCollectionView()
        viewModel.getDayStatistics()
        viewModel.fetchGoalObjects()
        setupCollectionView()
        setUpPictureSearch()
        
        viewModel.categories.subscribe {
            let boolValue = $0[0].items.isEmpty
            self.collectionViewCategoriesPercantage.isHidden = boolValue
            self.categoryLabel.isHidden = boolValue
            self.searchImage.isHidden = !boolValue
            self.label.isHidden = boolValue
            self.subLabel.isHidden = boolValue
        }.disposed(by: disposeBag)
    }
    
    
    @objc func tappedMenuButton(){
        self.delegate?.didTapButtonMenu()
    }
    
    
    @objc func addMenu(){
        let controller = CostViewController()
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
            self.viewModel.getDayStatistics()
            self.viewModel.getDayLabelText()
            self.viewModel.getCircleDay()
            self.viewWithCircleContainer.layer.sublayers?.forEach({
                $0.isHidden = true
            })
            self.addButton.isHidden = false
            self.label.isHidden = false
            self.subLabel.isHidden = false
            for layer in CircleCategories(circleValue: Int(self.view.frame.width * 0.76) / 2).getCategoriesLayer(percentDict: self.arrayOfCategoriesSection){
                self.viewWithCircleContainer.layer.addSublayer(layer)
                print(layer)
            }
        }), for:  .touchUpInside)
        
        buttons.buttonMonth.addAction(UIAction(handler: { _ in
            self.buttons.buttonDay.setTitleColor(.systemGray2, for: .normal)
            self.buttons.buttonMonth.setTitleColor(.black, for: .normal)
            self.buttons.buttonYear.setTitleColor(.systemGray2, for: .normal)
            self.viewModel.getMonthStatistics()
            self.viewModel.getMonthLabelText()
            self.viewModel.getCircleMonth()
            self.viewWithCircleContainer.layer.sublayers?.forEach({
                $0.isHidden = true
            })
            self.addButton.isHidden = false
            self.label.isHidden = false
            self.subLabel.isHidden = false
            for layer in CircleCategories(circleValue: Int(self.view.frame.width * 0.76) / 2).getCategoriesLayer(percentDict: self.arrayOfCategoriesSection){
                self.viewWithCircleContainer.layer.addSublayer(layer)
                print(layer)
            }
        }), for: .touchUpInside)
        
        buttons.buttonYear.addAction(UIAction(handler: { _ in
            self.buttons.buttonDay.setTitleColor(.systemGray2, for: .normal)
            self.buttons.buttonMonth.setTitleColor(.systemGray2, for: .normal)
            self.buttons.buttonYear.setTitleColor(.black, for: .normal)
            self.viewModel.getYearStatistics()
            self.viewModel.getYearLabelText()
            self.viewModel.getCircleYear()
            self.viewWithCircleContainer.layer.sublayers?.forEach({
                $0.isHidden = true
            })
            self.addButton.isHidden = false
            self.label.isHidden = false
            self.subLabel.isHidden = false
            for layer in CircleCategories(circleValue: Int(self.view.frame.width * 0.76) / 2).getCategoriesLayer(percentDict: self.arrayOfCategoriesSection){
                self.viewWithCircleContainer.layer.addSublayer(layer)
                print(layer)
            }
        }), for: .touchUpInside)
    }
}
extension CostScreen{
    
    func setupCollectionView(){
        categoryLabel.text = "Категории расходов"
        categoryLabel.textColor = .gray
        categoryLabel.font = .systemFont(ofSize: 20)
        stackView.addArrangedSubview(categoryLabel)
        
        stackView.addArrangedSubview(collectionViewCategoriesPercantage)
        stackView.setCustomSpacing(40, after: viewWithCircleContainer)
        collectionViewCategoriesPercantage.backgroundColor = .white
        NSLayoutConstraint.activate([
            collectionViewCategoriesPercantage.heightAnchor.constraint(equalToConstant: 220),
            collectionViewCategoriesPercantage.widthAnchor.constraint(equalToConstant: view.frame.width)
        
        ])
        stackView.setCustomSpacing(0, after: categoryLabel)
    }
    
    
    func bindCollectionView(){
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, CostCategoryModel>> { _, collectionView, indexPath, item in
            let indexOfLast = try! self.viewModel.categories.value()[0].items.count - 1
            if indexPath.row == indexOfLast{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExtraCell", for: indexPath) as! ExtraCell
                cell.percentLabel.text = "\(item.percents)%"
                cell.layer.shadowColor = UIColor.lightGray.cgColor
                cell.layer.shadowOpacity = 0.25
                cell.layer.shadowOffset = .zero
                cell.layer.shadowRadius = 20
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CellForCostScreen
                cell.categoryLabel.text = CategoryCostsDesignElements().getRussianLabelText()[item.category.rawValue]
                cell.sumLabel.text = "\(item.costsSum)"
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
            self.showCalendarViewControllerInACustomizedSheet(category: "auto")
        }.disposed(by: disposeBag)
        
    }
    
    func setUpPictureSearch(){
        searchImage.image = UIImage(named: "SearchGlass")
        searchImage.translatesAutoresizingMaskIntoConstraints = false
        searchImage.contentMode = .scaleAspectFit
        viewWithCircleContainer.addSubview(searchImage)
        NSLayoutConstraint.activate([
            searchImage.centerXAnchor.constraint(equalTo: viewWithCircleContainer.centerXAnchor),
            searchImage.centerYAnchor.constraint(equalTo: viewWithCircleContainer.centerYAnchor),
            searchImage.heightAnchor.constraint(equalToConstant: 100),
            searchImage.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func showCalendarViewControllerInACustomizedSheet(category: String) {
        let viewControllerToPresent = ListSortedCostsViewController(category: category, nibName: nil, bundle: nil)
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(viewControllerToPresent, animated: true)
    }
    
}
