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
  
  private lazy var musicFiles: [URL]! = {
    do {
      guard let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) else {
        throw Error.noFiles
      }
      return urls
    } catch {
      fatalError("Cannot find music files: \(error)")
    }
  }()
  
  private var musicFilesCopy: [URL] = []
  
  private var currentPlayer: AVAudioPlayer?
  
  private let dateComponentsFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.zeroFormattingBehavior = .pad
    formatter.allowedUnits = [.minute, .second]
    return formatter
  }()
  
  private(set) var elapsedTime: String?
  private(set) var totalTime: String?
  private(set) var progress: Float = 0
  
  func updateValues() {
    if let currentPlayer = currentPlayer {
      elapsedTime = dateComponentsFormatter.string(from: currentPlayer.currentTime)
      progress = Float(currentPlayer.duration > 0 ? currentPlayer.currentTime / currentPlayer.duration : 0.0)
    } else {
      elapsedTime = dateComponentsFormatter.string(from: 0)
      progress = 0
    }
  }
  
  func play() throws {
    if currentPlayer == nil {
      currentPlayer = try nextPlayer()
      totalTime = dateComponentsFormatter.string(from: currentPlayer!.duration)
    }
    guard currentPlayer!.play() else {
      throw Error.cantPlay
    }
  }
  
  func pause() {
    currentPlayer?.pause()
  }
  
  private func nextPlayer() throws -> AVAudioPlayer {
    if musicFilesCopy.isEmpty {
      musicFilesCopy = musicFiles
    }
    return try AVAudioPlayer(contentsOf: musicFiles.removeRandom(), fileTypeHint: AVFileTypeMPEGLayer3)
  }
}

extension PlayerViewModel {
  enum Error: Swift.Error {
    case noFiles
    case cantPlay
  }
}
