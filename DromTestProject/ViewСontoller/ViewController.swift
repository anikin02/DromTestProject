import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  var collectionView: UICollectionView!
  var refreshControl = UIRefreshControl()
  var imageURLs: [String] = [
    "https://burst.shopifycdn.com/photos/photo-of-a-cityscape-with-a-ferris-wheel.jpg?width=4460&height=4460&exif=0&iptc=0",
    "https://burst.shopifycdn.com/photos/landscape-of-green-rolling-hills-and-mountain-peaks.jpg?width=4460&height=4460&exif=0&iptc=0",
    "https://burst.shopifycdn.com/photos/two-people-in-a-car-look-at-a-map-while-smiling.jpg?width=4460&height=4460&exif=0&iptc=0",
    "https://burst.shopifycdn.com/photos/two-customized-cars-rolling-through-a-city-street.jpg?width=925&exif=0&iptc=0",
    "https://burst.shopifycdn.com/photos/bus-at-a-light-with-a-person-in-their-phone.jpg?width=925&exif=0&iptc=0",
    "https://burst.shopifycdn.com/photos/person-holds-a-book-over-a-stack-and-turns-the-page.jpg?width=925&exif=0&iptc=0"
  ]
  
  var imageCache = [String: UIImage]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    generateCollectionView()
  }
  
  func generateCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    
    // Настройка UIRefreshControl
    refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
    collectionView.refreshControl = refreshControl
    
    view.addSubview(collectionView)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageURLs.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
    
    let imageURL = imageURLs[indexPath.item]
    
    if let cachedImage = imageCache[imageURL] {
      cell.imageView.image = cachedImage
    } else {
      APIManager.shared.loadImage(from: imageURL) { image in
        DispatchQueue.main.async {
          if let image = image {
            self.imageCache[imageURL] = image
            cell.imageView.image = image
          }
        }
      }
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellSize = collectionView.frame.width - 20
    return CGSize(width: cellSize, height: cellSize)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }
    
    UIView.animate(withDuration: 0.5, animations: {
      cell.transform = CGAffineTransform(translationX: self.collectionView.frame.width, y: 0)
    }) { _ in
      self.imageURLs.remove(at: indexPath.item)
      collectionView.deleteItems(at: [indexPath])
      collectionView.performBatchUpdates(nil, completion: nil)
    }
  }
  
  @objc func refreshCollectionView() {
    imageURLs = [
      "https://burst.shopifycdn.com/photos/photo-of-a-cityscape-with-a-ferris-wheel.jpg?width=4460&height=4460&exif=0&iptc=0",
      "https://burst.shopifycdn.com/photos/landscape-of-green-rolling-hills-and-mountain-peaks.jpg?width=4460&height=4460&exif=0&iptc=0",
      "https://burst.shopifycdn.com/photos/two-people-in-a-car-look-at-a-map-while-smiling.jpg?width=4460&height=4460&exif=0&iptc=0",
      "https://burst.shopifycdn.com/photos/two-customized-cars-rolling-through-a-city-street.jpg?width=925&exif=0&iptc=0",
      "https://burst.shopifycdn.com/photos/bus-at-a-light-with-a-person-in-their-phone.jpg?width=925&exif=0&iptc=0",
      "https://burst.shopifycdn.com/photos/person-holds-a-book-over-a-stack-and-turns-the-page.jpg?width=925&exif=0&iptc=0"
    ]
    
    collectionView.reloadData()
    refreshControl.endRefreshing()
  }
}
