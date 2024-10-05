//
//  SceneDelegate.swift
//  DromTestProject
//
//  Created by anikin02 on 05.10.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(windowScene: windowScene)
    let navigationController = UINavigationController(rootViewController: ViewController())
    
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
}

