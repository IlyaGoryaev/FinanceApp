import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class CardViewController: UIViewController, UIScrollViewDelegate {
    
    let handleView = UIView()
    let grayView = UIView()
    let disposeBag = DisposeBag()
    let label = UILabel()
    let viewModel = CardViewModel()//Сделать private
    
    lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: 166, height: 90)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(CellForCostScreen.self, forCellWithReuseIdentifier: "Cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        grayView.translatesAutoresizingMaskIntoConstraints = false
        handleView.translatesAutoresizingMaskIntoConstraints = false
        grayView.layer.cornerRadius = 4
        view.addSubview(handleView)
        view.addSubview(grayView)
        NSLayoutConstraint.activate([
            handleView.topAnchor.constraint(equalTo: view.topAnchor),
            handleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            handleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            handleView.heightAnchor.constraint(equalToConstant: 30),
            grayView.topAnchor.constraint(equalTo: handleView.topAnchor, constant: 10),
            grayView.centerXAnchor.constraint(equalTo: handleView.centerXAnchor),
            grayView.heightAnchor.constraint(equalToConstant: 8),
            grayView.widthAnchor.constraint(equalToConstant: 30),
        ])
        grayView.backgroundColor = .systemGray3
        handleView.backgroundColor = .systemBackground
        view.backgroundColor = .systemBackground
        configureCollectionView()
        bindCollectionView()
        setupLabel()
    }
    
    private func setupLabel(){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Категории расходов"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .gray
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: handleView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])
        
    }
    
    private func configureCollectionView(){
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
    
    private func bindCollectionView(){
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, CostCategoryModel>> { _, collectionView, indexPath, item in
            if let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CellForCostScreen{
                cell.categoryLabel.text = CategoryCostsDesignElements().getRussianLabelText()[item.category.rawValue]
                
                cell.sumLabel.text = "\(item.costsSum)"
                cell.percentLabel.text = "\(item.percents)%"
                cell.colorImage.backgroundColor = item.color
                cell.backgroundColor = .systemGray6
                return cell
            }
            return UICollectionViewCell()
        }
        
        viewModel.categories.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        
    }
}
