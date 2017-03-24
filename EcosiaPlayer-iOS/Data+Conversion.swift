//
//  Data+Conversion.swift
//  EcosiaPlayer
//
//  Created by Igor Camilo on 23/03/17.
//  Copyright © 2017 Igor Camilo. All rights reserved.
//

import UIKit

extension Data {
  var image: UIImage? {
    return UIImage(data: self)
  }
}
