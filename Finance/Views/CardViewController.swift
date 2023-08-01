import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class CardViewController: UIViewController, UIScrollViewDelegate {
    
    let handleView = UIView()
    let grayView = UIView()
    let disposeBag = DisposeBag()
    let label = UILabel()
    
    lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: 166, height: 90)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(CellForMainScreen.self, forCellWithReuseIdentifier: "Cell")
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
            collectionView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func bindCollectionView(){
        let data = Observable.just([1, 2, 3, 4])
        data.bind(to: collectionView.rx.items){ collectionView, index, item in
            let indexPath = IndexPath(item: index, section: 0)
            let arrayColor: [UIColor] = [#colorLiteral(red: 0.5433602929, green: 0.7548330426, blue: 0.5191312432, alpha: 1), #colorLiteral(red: 0.9719435573, green: 0.295688808, blue: 0.2824983001, alpha: 1), #colorLiteral(red: 0.2864229083, green: 0.4874387383, blue: 0.9976932406, alpha: 1), #colorLiteral(red: 0.9960328937, green: 0.7385336757, blue: 0.171693176, alpha: 1)]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CellForMainScreen
            cell.backgroundColor = .systemGray6
            cell.colorImage.backgroundColor = arrayColor.randomElement()
            cell.percentLabel.text = "\(Int.random(in: 10...80))%"
            cell.sumLabel.text = "\(Int.random(in: 100...1000))"
            cell.layer.cornerRadius = 10
            return cell
        }.disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}
