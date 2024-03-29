//
//  PlayerViewController.swift
//  EcosiaPlayer
//
//  Created by Igor Camilo on 22/03/17.
//  Copyright © 2017 Igor Camilo. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
  
  private let playerViewModel = PlayerViewModel()
  
  /// Runs every frame.
  private var displayLink: CADisplayLink!
  
  @IBOutlet private var coverImageView: UIImageView!
  @IBOutlet private var trackNameLabel: UILabel!
  @IBOutlet private var artistLabel: UILabel!
  @IBOutlet private var currentTimeLabel: UILabel!
  @IBOutlet private var totalTimeLabel: UILabel!
  @IBOutlet private var progressView: UIProgressView!
  @IBOutlet private var playButton: UIButton!
  @IBOutlet private var stopButton: UIButton!
  
  @IBAction private func playButtonPressed() {
    do {
      playButton.isEnabled = false
      try playerViewModel.play { [weak self] in
        self?.playButton.isEnabled = true
        self?.updateUI()
      }
      displayLink.isPaused = false
    } catch {
      print(error)
    }
  }
  
  @IBAction private func stopButtonPressed() {
    playerViewModel.stop()
    updateUI()
    updateDynamicUI()
    displayLink.isPaused = true
  }
  
  /// Updates static and dynamic UI elements.
  private func updateUI() {
    coverImageView.image = playerViewModel.coverImage ?? #imageLiteral(resourceName: "Ecosia_logo_rgb")
    trackNameLabel.text = playerViewModel.title ?? " "
    artistLabel.text = playerViewModel.artist ?? " "
    totalTimeLabel.text = playerViewModel.totalTime
    let playing = playerViewModel.isPlaying
    playButton.isHidden = playing
    stopButton.isHidden = !playing
    updateDynamicUI()
  }
  
  /// Updates dynamic UI elements.
  @objc private func updateDynamicUI() {
    currentTimeLabel.text = playerViewModel.elapsedTime
    progressView.progress = Float(playerViewModel.progress)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
    // Configure behavior
    playerViewModel.didStopHandler = { [weak self] in
      self?.displayLink.isPaused = true
      self?.updateUI()
    }
    playerViewModel.didLoadMetadataHandler = { [weak self] in
      self?.updateUI()
    }
    // Configure update loop.
    displayLink = CADisplayLink(target: self, selector: #selector(updateDynamicUI))
    displayLink.add(to: .current, forMode: .defaultRunLoopMode)
  }
  
  deinit {
    displayLink.remove(from: .current, forMode: .defaultRunLoopMode)
  }
}
