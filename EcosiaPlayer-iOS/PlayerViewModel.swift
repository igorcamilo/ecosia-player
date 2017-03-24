//
//  PlayerViewModel.swift
//  EcosiaPlayer
//
//  Created by Igor Camilo on 22/03/17.
//  Copyright © 2017 Igor Camilo. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewModel: NSObject {

  /// List of all mp3 files URLs in the main bundle.
  private let musicFiles: [URL] = {
    guard let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) else {
      fatalError("Cannot find music files")
    }
    return urls
  }()

  /// Current music being played.
  fileprivate var currentPlayer: AVAudioPlayer? {
    didSet {
      currentPlayer?.delegate = self
      totalTime = currentPlayer?.durationString
    }
  }
  
  fileprivate var currentAsset: AVAsset? {
    didSet {
      title = nil
      artist = nil
      coverImage = nil
      guard let asset = currentAsset else {
        return
      }
      asset.loadValuesAsynchronously(forKeys: ["commonMetadata"]) { [weak self] in
        guard self?.currentAsset == asset else {
          return
        }
        self?.title = AVMetadataItem.metadataItems(from: asset.commonMetadata, withKey: AVMetadataCommonKeyTitle, keySpace: AVMetadataKeySpaceCommon).first?.stringValue
        self?.artist = AVMetadataItem.metadataItems(from: asset.commonMetadata, withKey: AVMetadataCommonKeyArtist, keySpace: AVMetadataKeySpaceCommon).first?.stringValue
        self?.coverImage = AVMetadataItem.metadataItems(from: asset.commonMetadata, withKey: AVMetadataCommonKeyArtwork, keySpace: AVMetadataKeySpaceCommon).first?.dataValue?.image
        DispatchQueue.main.async { [weak self] in
          self?.didLoadMetadataHandler?()
        }
      }
    }
  }
  
  var isPlaying: Bool {
    return currentPlayer?.isPlaying ?? false
  }
  
  private(set) var coverImage: UIImage?
  
  private(set) var title: String?
  
  private(set) var artist: String?
  
  var didLoadMetadataHandler: (() -> Void)?

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
  func play(completionHandler: (() -> Void)?) throws {
    if currentPlayer == nil {
      let url = musicFiles.randomElement()
      currentPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3)
      currentAsset = AVAsset(url: url)
    }
    let player = currentPlayer!
    DispatchQueue(label: "Play Async").async { [weak self] in
      player.prepareToPlay()
      DispatchQueue.main.async {
        if player == self?.currentPlayer {
          player.play()
        }
        completionHandler?()
      }
    }
  }

  /// Stops the current music.
  func stop() {
    currentPlayer?.stop()
    currentPlayer = nil
    currentAsset = nil
  }
  
  var didStopHandler: (() -> Void)?
}

extension PlayerViewModel {
  enum Error: Swift.Error {
    case cantPlay
  }
}

extension PlayerViewModel: AVAudioPlayerDelegate {
  
  private func endPlay() {
    currentPlayer = nil
    currentAsset = nil
    didStopHandler?()
  }
  
  func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Swift.Error?) {
    endPlay()
  }
  
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    endPlay()
  }
}
