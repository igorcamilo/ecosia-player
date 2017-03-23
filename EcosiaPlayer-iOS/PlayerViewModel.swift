//
//  PlayerViewModel.swift
//  EcosiaPlayer
//
//  Created by Igor Camilo on 22/03/17.
//  Copyright © 2017 Igor Camilo. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewModel {

  /// List of all mp3 files URLs in the main bundle.
  private let musicFiles: [URL] = {
    guard let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) else {
      fatalError("Cannot find music files")
    }
    return urls
  }()

  /// Current music being played.
  private var currentPlayer: AVAudioPlayer? {
    didSet {
      totalTime = currentPlayer?.durationString
    }
  }

  /// Formatted total time of music.
  private(set) var totalTime: String?

  /// Formatted current time of music.
  var elapsedTime: String? {
    return currentPlayer?.currentTimeString
  }

  /// Percentage of music already played. Varies from 0.0 to 1.0.
  var progress: Double {
    return currentPlayer?.progress ?? 0.0
  }

  /// Selects a random mp3 from bundle and plays it.
  func play() throws {
    if currentPlayer == nil {
      currentPlayer = try AVAudioPlayer(contentsOf: musicFiles.randomElement(), fileTypeHint: AVFileTypeMPEGLayer3)
    }
    guard currentPlayer!.play() else {
      throw Error.cantPlay
    }
  }

  /// Stops the current music.
  func stop() {
    currentPlayer?.stop()
    currentPlayer = nil
  }
}

extension PlayerViewModel {
  enum Error: Swift.Error {
    case cantPlay
  }
}

// TODO: Move to AVAudioPlayer+Formatter.swift

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
