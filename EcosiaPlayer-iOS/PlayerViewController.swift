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
  
  private var displayLink: CADisplayLink!
  
  @IBOutlet private var coverImageView: UIImageView!
  @IBOutlet private var trackNameLabel: UILabel!
  @IBOutlet private var artistLabel: UILabel!
  @IBOutlet private var currentTimeLabel: UILabel!
  @IBOutlet private var totalTimeLabel: UILabel!
  @IBOutlet private var progressView: UIProgressView!
  @IBOutlet private var playButton: UIButton!
  @IBOutlet private var pauseButton: UIButton!
  
  @IBAction private func playButtonPressed() {
    do {
      try playerViewModel.play()
      playButton.isHidden = true
      pauseButton.isHidden = false
      displayLink.isPaused = false
    } catch {
      print(error)
    }
  }
  
  @IBAction private func pauseButtonPressed() {
    playerViewModel.stop()
    playButton.isHidden = false
    pauseButton.isHidden = true
    displayLink.isPaused = true
    updateUI()
  }
  
  @objc private func updateUI() {
    currentTimeLabel.text = playerViewModel.elapsedTime
    totalTimeLabel.text = playerViewModel.totalTime
    progressView.progress = Float(playerViewModel.progress)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
    displayLink = CADisplayLink(target: self, selector: #selector(updateUI))
    displayLink.add(to: .current, forMode: .defaultRunLoopMode)
  }
  
  deinit {
    displayLink.remove(from: .current, forMode: .defaultRunLoopMode)
  }
}
