//
//  AppDelegate.swift
//  EcosiaPlayer-iOS
//
//  Created by Igor Camilo on 22/03/17.
//  Copyright © 2017 Igor Camilo. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    
    window?.tintColor = #colorLiteral(red: 0.862745098, green: 0.4941176471, blue: 0.3450980392, alpha: 1)
    
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print(error)
    }
    
    return true
  }
}
