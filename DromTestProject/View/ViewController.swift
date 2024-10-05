//
//  CollectionViewCell.swift
//  DromTestProject
//
//  Created by anikin02 on 05.10.2024.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  private var collectionView: UICollectionView!
  private var refreshControl = UIRefreshControl()
  private var imageURLs: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    
    imageURLs = DataManager.shared.imageURLs
    
    generateCollectionView()
  }
  
  private func generateCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    
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
    
    if let cachedImage = DataManager.shared.loadImageFromCache(url: imageURL) {
      cell.imageView.image = cachedImage
    } else {
      APIManager.shared.loadImage(from: imageURL) { image in
        DispatchQueue.main.async {
          if let image = image {
            DataManager.shared.saveImageToCache(url: imageURL, image: image)
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
    imageURLs = DataManager.shared.imageURLs
    
    collectionView.reloadData()
    refreshControl.endRefreshing()
  }
}
