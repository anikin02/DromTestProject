//
//  DataManager.swift
//  DromTestProject
//
//  Created by anikin02 on 05.10.2024.
//

import Foundation
import UIKit

class DataManager {
  static let shared = DataManager()
  
  var imageURLs: [String] = [
    "https://burst.shopifycdn.com/photos/photo-of-a-cityscape-with-a-ferris-wheel.jpg?width=4460&height=4460&exif=0&iptc=0",
    "https://burst.shopifycdn.com/photos/landscape-of-green-rolling-hills-and-mountain-peaks.jpg?width=4460&height=4460&exif=0&iptc=0",
    "https://burst.shopifycdn.com/photos/two-people-in-a-car-look-at-a-map-while-smiling.jpg?width=4460&height=4460&exif=0&iptc=0",
    "https://burst.shopifycdn.com/photos/two-customized-cars-rolling-through-a-city-street.jpg?width=925&exif=0&iptc=0",
    "https://burst.shopifycdn.com/photos/bus-at-a-light-with-a-person-in-their-phone.jpg?width=925&exif=0&iptc=0",
    "https://burst.shopifycdn.com/photos/person-holds-a-book-over-a-stack-and-turns-the-page.jpg?width=925&exif=0&iptc=0"
  ]
  
  var imageCache = [String: UIImage]()
  
  // MARK: - Save image to file system
  func saveImageToCache(url: String, image: UIImage) {
    guard let data = image.pngData() else { return }
    let filename = getDocumentsDirectory().appendingPathComponent(URL(string: url)!.lastPathComponent)
    
    do {
      try data.write(to: filename)
      imageCache[url] = image
    } catch {
      print("Failed to save image: \(error)")
    }
  }
  
  // MARK: - Load image from file system
  func loadImageFromCache(url: String) -> UIImage? {
    if let cachedImage = imageCache[url] {
      return cachedImage
    }
    
    let filename = getDocumentsDirectory().appendingPathComponent(URL(string: url)!.lastPathComponent)
    
    if let image = UIImage(contentsOfFile: filename.path) {
      imageCache[url] = image
      return image
    }
    
    return nil
  }
  
  // MARK: - Get documents directory
  private func getDocumentsDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}
