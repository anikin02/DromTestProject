//
//  APIManager.swift
//  DromTestProject
//
//  Created by anikin02 on 05.10.2024.
//

import UIKit

class APIManager {
  
  static let shared = APIManager()
  
  func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
      guard let url = URL(string: urlString) else {
          print("Невалидный URL: \(urlString)")
          completion(nil)
          return
      }
      
      URLSession.shared.dataTask(with: url) { data, response, error in
          if let error = error {
              print("Ошибка загрузки изображения: \(error)")
              completion(nil)
              return
          }
          
          if let data = data, let image = UIImage(data: data) {
              completion(image)
          } else {
              completion(nil)
          }
      }.resume()
  }
}
