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
      oldValue?.cancelLoading()
      title = nil
      artist = nil
      coverImage = nil
      guard let asset = currentAsset else {
        return
      }
      currentAsset?.loadValuesAsynchronously(forKeys: [AVMetadataCommonKeyTitle, AVMetadataCommonKeyArtist, AVMetadataCommonKeyArtwork]) { [weak self] () -> Void in
        self?.title = AVMetadataItem.metadataItems(from: asset.commonMetadata, withKey: AVMetadataCommonKeyTitle, keySpace: AVMetadataKeySpaceCommon).first?.stringValue
        self?.artist = AVMetadataItem.metadataItems(from: asset.commonMetadata, withKey: AVMetadataCommonKeyArtist, keySpace: AVMetadataKeySpaceCommon).first?.stringValue
        self?.coverImage = AVMetadataItem.metadataItems(from: asset.commonMetadata, withKey: AVMetadataCommonKeyArtwork, keySpace: AVMetadataKeySpaceCommon).first?.dataValue?.image
      }
    }
  }
  
  var isPlaying: Bool {
    return currentPlayer?.isPlaying ?? false
  }
  
  private(set) var coverImage: UIImage?
  
  private(set) var title: String?
  
  private(set) var artist: String?

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
      let url = musicFiles.randomElement()
      currentPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3)
      currentAsset = AVAsset(url: musicFiles.randomElement())
    }
    guard currentPlayer!.play() else {
      throw Error.cantPlay
    }
  }

  /// Stops the current music.
  func stop() {
    currentPlayer?.stop()
    currentPlayer = nil
    currentAsset = nil
  }
  
  var stopHandler: (() -> Void)?
}

extension PlayerViewModel {
  enum Error: Swift.Error {
    case cantPlay
  }
}

extension PlayerViewModel: AVAudioPlayerDelegate {
  public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    currentPlayer = nil
    currentAsset = nil
    stopHandler?()
  }
}
