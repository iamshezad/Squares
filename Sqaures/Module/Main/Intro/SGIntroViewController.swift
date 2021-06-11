//
//  SGIntroViewController.swift
//  Sqaures
//
//  Created by Shezad Ahamed on 05/06/21.
//

import UIKit

class SGIntroViewController: UIViewController {

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levelTableView: UITableView!
    
    var levelData: [String] = ["Game: Select and memorize a number from each set of random numbers.", "Time: You got 1 minute to complete this level.", "Controls: Tilt your device to move the square around the numbers and for selection tap on the square.", "Hint: It's about your memory and calculation skill."]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func gameAction(_ sender: UIButton) {
        if let targetVC = SGStoryboards.game.instantiateViewController(identifier: "SGGameViewController") as? SGGameViewController{
            self.show(targetVC, sender: nil)
        }
    }
    
}

extension SGIntroViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        levelData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SGLevelDescriptionTableViewCell", for: indexPath) as? SGLevelDescriptionTableViewCell{
            cell.descriptionLabel.text = levelData[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
