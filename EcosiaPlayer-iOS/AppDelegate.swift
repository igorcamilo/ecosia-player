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
    
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
    } catch {
      print(error)
    }
    
    return true
  }
}
