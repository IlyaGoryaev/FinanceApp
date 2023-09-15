import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import DGCharts

final class IncomeScreen: UIViewController, UIScrollViewDelegate, ScreenProtocol {
    
    private let infoButton = InfoButton()
    private let buttons = Buttons()
    private let categoryLabel = UILabel()
    private let noIncomes = UILabel()
    let pieChart = CustomPieChart()
    
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
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: IncomeScreenViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        let chosen = try! self.viewModel?.incomeDescription.value()
        switch chosen?.period{
        case .Day:
            self.viewModel?.setUpScreen(periodId: .Day)
            setupPieChartLabel()
        case .Month:
            self.viewModel?.setUpScreen(periodId: .Month)
            setupPieChartLabel()
        case .Year:
            self.viewModel?.setUpScreen(periodId: .Year)
            setupPieChartLabel()
        case .none:
            break
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        viewModel = IncomeScreenViewModel(viewController: self)
        
        setUpTheme()
        setUpView()
        setUpButtons()
        setUpInfoButtons()
        setupPieChart()
        setUpNoLabel()
        bindCollectionView()
        setupCollectionView()
        
        viewModel!.categories.subscribe {
            let boolValue = $0[0].items.isEmpty
            self.collectionViewCategoriesPercantage.isHidden = boolValue
            self.categoryLabel.isHidden = boolValue
        }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addMenu(){
        let controller = IncomeViewController()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showCalendarViewControllerInACustomizedSheet(category: String) {
        let viewControllerToPresent = ListSortedIncomesViewController(category: category, periodId: Period(rawValue: (try! self.viewModel?.incomeDescription.value().period)!.rawValue) ?? .Day, nibName: nil, bundle: nil)
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(viewControllerToPresent, animated: true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.infoButton.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        
    }
    
}
//MARK: - ViewElements
private extension IncomeScreen{
    
    func setUpTheme(){
        let theme = Theme(rawValue: UserDefaults.standard.integer(forKey: "app_theme"))
        theme!.setActive()
    }
    
    func setUpNoLabel(){
        stackView.addArrangedSubview(noIncomes)
        noIncomes.text = "За данный период нет доходов"
        noIncomes.textColor = UIColor(named: "SemiBoldColor")
        noIncomes.font = .boldSystemFont(ofSize: 20)
        
        viewModel?.isCategoryEmpty.subscribe {
            self.noIncomes.isHidden = !$0
        }.disposed(by: disposeBag)
    }
    
    func setUpView(){
        view.backgroundColor = UIColor(named: "FinanceBackgroundColor")
        navigationController?.navigationBar.isHidden = true
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
    }
    
    func setupViewConstraints(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func setUpButtons(){
        buttons.buttonDay.titleLabel?.font = .boldSystemFont(ofSize: self.view.frame.width * 0.09)
        buttons.buttonMonth.titleLabel?.font = .boldSystemFont(ofSize: self.view.frame.width * 0.09)
        buttons.buttonYear.titleLabel?.font = .boldSystemFont(ofSize: self.view.frame.width * 0.09)
        buttons.buttonDay.addAction(UIAction(handler: { _ in
            self.buttons.setUpDayStyle()
            self.viewModel?.setUpScreen(periodId: .Day)
            self.setupPieChartLabel()
        }), for:  .touchUpInside)
        
        buttons.buttonMonth.addAction(UIAction(handler: { _ in
            self.buttons.setUpMonthStyle()
            self.viewModel?.setUpScreen(periodId: .Month)
            self.setupPieChartLabel()
        }), for: .touchUpInside)
        
        buttons.buttonYear.addAction(UIAction(handler: { _ in
            self.buttons.setUpYearStyle()
            self.viewModel?.setUpScreen(periodId: .Year)
            self.setupPieChartLabel()
        }), for: .touchUpInside)
    }
    
    func setUpInfoButtons(){
        pieChart.addSubview(infoButton)
        NSLayoutConstraint.activate([
            infoButton.trailingAnchor.constraint(equalTo: pieChart.trailingAnchor, constant: -16),
            infoButton.bottomAnchor.constraint(equalTo: pieChart.bottomAnchor, constant: -16),
            infoButton.heightAnchor.constraint(equalToConstant: 50),
            infoButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        infoButton.addTarget(self, action: #selector(addMenu), for: .touchUpInside)
    }
    
    func setupPieChart(){
        pieChart.delegate = self
        self.viewModel?.setUpScreen(periodId: .Day)
        stackView.addArrangedSubview(pieChart)
        stackView.setCustomSpacing(0, after: buttons)
        pieChart.snp.makeConstraints { make in
            make.height.equalTo(view.frame.width * 0.95)
            make.width.equalTo(view.frame.width * 0.95)
        }
        pieChart.holeColor = NSUIColor(named: "FinanceBackgroundColor")
    }
    
    func setupPieChartLabel(){
        let incomeScreen = try! viewModel?.incomeDescription.value()
        let centerText = NSAttributedString(
            string: String(incomeScreen?.sumIncome ?? 0) + " ₽",
            attributes: [
                .font : UIFont.systemFont(ofSize: 20, weight: .bold),
                .foregroundColor : UIColor(named: "BoldLabelsColor")!
            ])
        pieChart.centerAttributedText = centerText
    }
}
//MARK: - CollectionView
private extension IncomeScreen{
    
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
        
        viewModel?.categories.bind(to: collectionViewCategoriesPercantage.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        collectionViewCategoriesPercantage.rx.setDelegate(self).disposed(by: disposeBag)
        
        collectionViewCategoriesPercantage.rx.itemSelected.subscribe {
            let categories = try! self.viewModel?.categories.value()
            self.showCalendarViewControllerInACustomizedSheet(category: categories?[0].items[$0.element!.row].category.rawValue ?? "")
        }.disposed(by: disposeBag)
        
    }
    
}
//MARK: - PieChartDelegate
extension IncomeScreen: ChartViewDelegate{
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let categoriesArray = try! viewModel?.incomeDescription.value().categories.map({ costCategoryModel in
            costCategoryModel.category.rawValue
        })
        collectionViewCategoriesPercantage.scrollToItem(at: IndexPath(row: categoriesArray?.firstIndex(of: entry.data as! String) ?? 0, section: 0), at: [.centeredHorizontally], animated: true)
    }
    
}
