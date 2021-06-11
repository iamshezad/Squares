//
//  SGLevelViewController.swift
//  Sqaures
//
//  Created by Shezad Ahamed on 05/06/21.
//

import UIKit

class SGLevelViewController: UIViewController {

    @IBOutlet weak var levelCollectionView: UICollectionView!
    
    var unlockedLevels: [Int] = [0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension SGLevelViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 36
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SGLevelCollectionViewCell", for: indexPath) as? SGLevelCollectionViewCell{
            
            //Level number
            cell.numberLabel.text = "\(indexPath.item + 1)"
            
            //Unlocked level
            if unlockedLevels.contains(indexPath.item){
                cell.squareView.backgroundColor = .white
            }else{
                cell.squareView.backgroundColor = .white.withAlphaComponent(0.4)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let squareSize = collectionView.frame.size.width/6
        return CGSize(width: squareSize, height: squareSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if unlockedLevels.contains(indexPath.item){
            if let targetVC = SGStoryboards.main.instantiateViewController(identifier: "SGIntroViewController") as? SGIntroViewController{
                self.show(targetVC, sender: nil)
            }
        }
    }
    
}
