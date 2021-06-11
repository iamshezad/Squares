//
//  UILabelExtension.swift
//  Sqaures
//
//  Created by Shezad Ahamed on 03/06/21.
//

import UIKit
import AudioToolbox

extension UILabel{
    
    //MARK:- Typing Animation
    func setTyping(text: String, characterDelay: TimeInterval = 6.0) {
      self.text = ""
        
      let writingTask = DispatchWorkItem { [weak self] in
        text.forEach { char in
          DispatchQueue.main.async {
            self?.text?.append(char)
            self?.playSound()
          }
          Thread.sleep(forTimeInterval: characterDelay/100)
        }
      }
        
      let queue: DispatchQueue = .init(label: "typespeed", qos: .userInteractive)
      queue.asyncAfter(deadline: .now() + 0.05, execute: writingTask)
    }
    
    func playSound(){
        let systemSoundID: SystemSoundID = 1104//1004
        // to play sound
        AudioServicesPlaySystemSound (systemSoundID)
    }

}
