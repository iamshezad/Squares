//
//  SGGameAlertViewController.swift
//  Sqaures
//
//  Created by Shezad Ahamed on 05/06/21.
//

protocol GameAlertProtocol {
    func retry()
    func level()
}

import UIKit

class SGGameAlertViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emoticonImageView: UIImageView!
    @IBOutlet weak var retryButton: UIButton!
    
    var gameState: GameState = .won
    
    var delegate: GameAlertProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if gameState == .won{
            titleLabel.text = "Level Completed"
            emoticonImageView.image = #imageLiteral(resourceName: "happy")
            retryButton.isHidden = true
        }else{
            titleLabel.text = "Game Over"
            emoticonImageView.image = #imageLiteral(resourceName: "sad")
        }

    }

    @IBAction func levelsAction(_ sender: UIButton) {
        delegate?.level()
        self.dismiss(animated: false) {}
    }
    
    @IBAction func retryAction(_ sender: UIButton) {
        delegate?.retry()
        self.dismiss(animated: false) {}
    }
    
}
