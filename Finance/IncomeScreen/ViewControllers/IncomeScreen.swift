import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import DGCharts

class IncomeScreen: UIViewController, UIScrollViewDelegate {
    
    let infoButton = UIButton()
    
    //MARK: Круговая диаграмма доходов
    let pieChart = PieChartView()
    
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "FinanceBackgroundColor")
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
        scrollView.backgroundColor = UIColor(named: "FinanceBackgroundColor")
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = contentSize
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    //MARK: Контейнер для ScrollView
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor(named: "FinanceBackgroundColor")
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
        view.backgroundColor = UIColor(named: "FinanceBackgroundColor")
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
        
        //MARK: Настройка кнопок периода
        setUpButtons()
        
        stackView.addArrangedSubview(buttons)
        
        
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        infoButton.titleLabel?.font = .boldSystemFont(ofSize: 30)
        infoButton.tintColor = UIColor(named: "BoldLabelsColor")
        pieChart.addSubview(infoButton)
        NSLayoutConstraint.activate([
            infoButton.trailingAnchor.constraint(equalTo: pieChart.trailingAnchor, constant: -16),
            infoButton.bottomAnchor.constraint(equalTo: pieChart.bottomAnchor, constant: -16),
            infoButton.heightAnchor.constraint(equalToConstant: 50),
            infoButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        infoButton.backgroundColor = UIColor(named: "FinanaceMainScreenCellColor")
        infoButton.layer.cornerRadius = 25
        infoButton.layer.shadowOpacity = 0.5
        infoButton.layer.shadowOffset = .zero
        infoButton.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        infoButton.layer.shadowRadius = 15
        infoButton.addTarget(self, action: #selector(addMenu), for: .touchUpInside)
        
        
        viewModel.percentArray.subscribe {
            self.arrayOfCategoriesSection = $0
        }.disposed(by: disposeBag)
        
        setupPieChart()
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
        }.disposed(by: disposeBag)
        
        noIncomes.isHidden = true
    }
    
    
    @objc func addMenu(){
        let controller = IncomeViewController()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(controller, animated: true)
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
            self.buttons.buttonDay.setTitleColor(UIColor(named: "BoldLabelsColor"), for: .normal)
            self.buttons.buttonMonth.setTitleColor(UIColor(named: "MainScreenButtonsColor2"), for: .normal)
            self.buttons.buttonYear.setTitleColor(UIColor(named: "MainScreenButtonsColor2"), for: .normal)
            self.setupDay()
        }), for:  .touchUpInside)
        
        buttons.buttonMonth.addAction(UIAction(handler: { _ in
            self.buttons.buttonDay.setTitleColor(UIColor(named: "MainScreenButtonsColor2"), for: .normal)
            self.buttons.buttonMonth.setTitleColor(UIColor(named: "BoldLabelsColor"), for: .normal)
            self.buttons.buttonYear.setTitleColor(UIColor(named: "MainScreenButtonsColor2"), for: .normal)
            self.setupMonth()
        }), for: .touchUpInside)
        
        buttons.buttonYear.addAction(UIAction(handler: { _ in
            self.buttons.buttonDay.setTitleColor(UIColor(named: "MainScreenButtonsColor2"), for: .normal)
            self.buttons.buttonMonth.setTitleColor(UIColor(named: "MainScreenButtonsColor2"), for: .normal)
            self.buttons.buttonYear.setTitleColor(UIColor(named: "BoldLabelsColor"), for: .normal)
            self.setupYear()
        }), for: .touchUpInside)
    }
}
extension IncomeScreen{
    func setupCollectionView(){
        categoryLabel.text = "Категории доходов"
        categoryLabel.textColor = UIColor(named: "BoldLabelsColor")
        categoryLabel.font = .systemFont(ofSize: 20)
        stackView.addArrangedSubview(categoryLabel)
        
        stackView.addArrangedSubview(collectionViewCategoriesPercantage)
        stackView.setCustomSpacing(0, after: pieChart)
        collectionViewCategoriesPercantage.backgroundColor = UIColor(named: "FinanceBackgroundColor")
        NSLayoutConstraint.activate([
            collectionViewCategoriesPercantage.heightAnchor.constraint(equalToConstant: view.frame.height * 0.26),
            collectionViewCategoriesPercantage.widthAnchor.constraint(equalToConstant: view.frame.width)
        
        ])
        stackView.setCustomSpacing(0, after: categoryLabel)
    }
    
    
    func bindCollectionView(){
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, IncomeCategoryModel>> { _, collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CellForIncomeScreen
            cell.categoryLabel.text = CategoryIncomeDesignElements().getRussianLabelText()[item.category.rawValue]
            cell.sumLabel.text = "\(item.incomeSum)"
            cell.percentLabel.text = "\(item.percents)%"
            cell.sumLabel.textColor = UIColor(named: "SemiBoldColor")
            cell.percentLabel.textColor = UIColor(named: "SemiBoldColor")
            cell.colorImage.backgroundColor = item.color
            cell.backgroundColor = UIColor(named: "FinanaceMainScreenCellColor")
            
            return cell
        }
        
        viewModel.categories.bind(to: collectionViewCategoriesPercantage.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        collectionViewCategoriesPercantage.rx.setDelegate(self).disposed(by: disposeBag)
        
        collectionViewCategoriesPercantage.rx.itemSelected.subscribe {
            let categories = try! self.viewModel.categories.value()
            self.showCalendarViewControllerInACustomizedSheet(category: categories[0].items[$0.element!.row].category.rawValue)
        }.disposed(by: disposeBag)
        
    }
    
    func showCalendarViewControllerInACustomizedSheet(category: String) {
        let viewControllerToPresent = ListSortedIncomesViewController(category: category, periodId: try! self.viewModel.categoryChosen.value(), nibName: nil, bundle: nil)
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(viewControllerToPresent, animated: true)
    }
    
    func setupDay(){
        var dateComponents = DateComponents()
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        let dict = GetIncomeStatistic().getDayPercent(dateComponents: dateComponents)
        pieChart.drawCenterTextEnabled = true
        
        pieChart.centerText = "За сегодня"
        
        var entries = [PieChartDataEntry]()
        var colors = [UIColor]()
        for (category, value) in dict.0{
            if value != 0{
                entries.append(PieChartDataEntry(value: value * 100))
                colors.append(CategoryIncomeDesignElements().getCategoryColors()[category]!)
            }
        }
        
        let set = PieChartDataSet(entries: entries, label: String())
        let data = PieChartData(dataSet: set)
        set.colors = colors
        pieChart.data = data
        self.viewModel.getDayStatistics()
        self.viewModel.categoryChosen.on(.next(1))
    }
    
    func setupMonth(){
        var dateComponents = DateComponents()
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        let dict = GetIncomeStatistic().getMonthPercent(dateComponents: dateComponents)
        pieChart.drawCenterTextEnabled = true
        
        pieChart.centerText = "За месяц"
        
        var entries = [PieChartDataEntry]()
        var colors = [UIColor]()
        for (category, value) in dict.0{
            if value != 0{
                entries.append(PieChartDataEntry(value: value * 100))
                colors.append(CategoryIncomeDesignElements().getCategoryColors()[category]!)
            }
        }
        
        let set = PieChartDataSet(entries: entries, label: String())
        let data = PieChartData(dataSet: set)
        set.colors = colors
        pieChart.data = data
        self.viewModel.getMonthStatistics()
        self.viewModel.categoryChosen.on(.next(2))
    }
    
    func setupYear(){
        let dict = GetIncomeStatistic().getYearPercent()
        pieChart.drawCenterTextEnabled = true
        
        pieChart.centerText = "За год"
        
        var entries = [PieChartDataEntry]()
        var colors = [UIColor]()
        for (category, value) in dict.0{
            if value != 0{
                entries.append(PieChartDataEntry(value: value * 100))
                colors.append(CategoryIncomeDesignElements().getCategoryColors()[category]!)
            }
        }
        
        let set = PieChartDataSet(entries: entries, label: String())
        let data = PieChartData(dataSet: set)
        set.colors = colors
        pieChart.data = data
        self.viewModel.getYearStatistics()
        self.viewModel.categoryChosen.on(.next(3))
    }
    
    private func setupPieChart(){
        
        var dateComponents = DateComponents()
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        let dict = GetIncomeStatistic().getDayPercent(dateComponents: dateComponents)
        
        stackView.addArrangedSubview(pieChart)
        stackView.setCustomSpacing(0, after: buttons)
        pieChart.drawCenterTextEnabled = true
        pieChart.usePercentValuesEnabled = false
            
        pieChart.centerText = "За сегодня"
        pieChart.rotationEnabled = false
        pieChart.legend.enabled = false
        pieChart.drawEntryLabelsEnabled = false
        
        var entries = [PieChartDataEntry]()
        var colors = [UIColor]()
        for (category, value) in dict.0{
            if value != 0{
                let entry = PieChartDataEntry(value: value * 100)
                entries.append(entry)
                colors.append(CategoryIncomeDesignElements().getCategoryColors()[category]!)
            }
        }
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.entryLabelColor = NSUIColor.black
        set.drawIconsEnabled = false
        let data = PieChartData(dataSet: set)
        set.colors = colors
        pieChart.data?.setDrawValues(false)
        pieChart.data = data
        
        pieChart.snp.makeConstraints { make in
            make.height.equalTo(view.frame.width * 0.95)
            make.width.equalTo(view.frame.width * 0.95)
        }
        
        pieChart.holeColor = NSUIColor(named: "FinanceBackgroundColor")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.infoButton.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        
    }
}
