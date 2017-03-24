//
//  AVAudioPlayer+Formatter.swift
//  EcosiaPlayer
//
//  Created by Igor Camilo on 23/03/17.
//  Copyright © 2017 Igor Camilo. All rights reserved.
//

import AVFoundation

private let dateComponentsFormatter: DateComponentsFormatter = {
  let formatter = DateComponentsFormatter()
  formatter.zeroFormattingBehavior = .pad
  formatter.allowedUnits = [.minute, .second]
  return formatter
}()

extension AVAudioPlayer {
  var durationString: String? {
    return dateComponentsFormatter.string(from: duration)
  }
  var currentTimeString: String? {
    return dateComponentsFormatter.string(from: currentTime)
  }
  var progress: Double {
    return duration > 0 ? currentTime / duration : 0.0
  }
}
