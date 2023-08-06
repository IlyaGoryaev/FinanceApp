import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class AddGoalViewController: UIViewController, UIScrollViewDelegate {
    
    let disposeBag = DisposeBag()
    
    
    lazy var collectionViewForIcons: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: 40, height: 40)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionViewFlowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(CollectionViewForIconsCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewForIcon()
        bindCollectionViewForIcon()

        
    }
}
extension AddGoalViewController{
    
    private func setupCollectionViewForIcon(){
        view.addSubview(collectionViewForIcons)
        NSLayoutConstraint.activate([
            collectionViewForIcons.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionViewForIcons.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionViewForIcons.heightAnchor.constraint(equalToConstant: 320),
            collectionViewForIcons.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindCollectionViewForIcon(){
        
        let data = Observable.just(["🏖️", "🚗", "🥂", "⚽️", "🎤", "🚛", "✈️", "🛳️" ,"🚀", "🚁", "🚲", "🎲", "🏢", "🏠", "💻", "🖥️", "🖨️", "📱" ,"⌚️", "📷", "💿", "🔫", "💎", "⚙️", "🛶", "💵", "👫", "👠" ,"👕", "💍", "🕶️", "👓", "🐶", "🌳", "🪵", "🍏", "🎂", "🥅" ,"⛳️", "🏆", ])
        
        data.bind(to: collectionViewForIcons.rx.items){collectionView, index, item in
            let indexPath = IndexPath(item: index, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewForIconsCell
            cell.label.text = item
            cell.label.font = .boldSystemFont(ofSize: 40)
            return cell
        }.disposed(by: disposeBag)
        
        collectionViewForIcons.rx.itemSelected.subscribe {
            
            
        }.disposed(by: disposeBag)
        
        collectionViewForIcons.rx.itemDeselected.subscribe {
            
            
        }.disposed(by: disposeBag)
        
        collectionViewForIcons.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
}
