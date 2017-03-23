//
//  Array+Random.swift
//  EcosiaPlayer
//
//  Created by Igor Camilo on 22/03/17.
//  Copyright © 2017 Igor Camilo. All rights reserved.
//

import Foundation

extension Array {
  func randomElement() -> Element {
    return self[Int(arc4random_uniform(UInt32(self.count)))]
  }
}
