//
//  SGMainViewController.swift
//  Sqaures
//
//  Created by Shezad Ahamed on 03/06/21.
//

import UIKit

class SGMainViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3 , execute: {
            //Animate Text
            self.titleLabel.setTyping(text: "Squares")
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.8 , execute: {
            self.setupScreens()
        })
        
    }
    
    //MARK:- Setup game screens
    func setupScreens(){
        let targetVC = SGStoryboards.main.instantiateViewController(identifier: "SGLevelNavigationController")
        targetVC.modalPresentationStyle = .overFullScreen
        targetVC.modalTransitionStyle = .flipHorizontal
        self.present(targetVC, animated: true, completion: nil)
    }
}
