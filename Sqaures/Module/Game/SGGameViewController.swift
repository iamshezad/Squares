//
//  SGGameViewController.swift
//  Sqaures
//
//  Created by Shezad Ahamed on 03/06/21.
//

import UIKit
import CoreMotion
import AudioToolbox

class SGGameViewController: UIViewController {
    
    @IBOutlet weak var gameBackgroundView: UIView!
    @IBOutlet weak var gameCollectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    let motionManager = CMMotionManager()
    
    private var currentIndex: Int = 0
    
    private var topEnd: [Int] = [0, 1, 2, 3, 4, 5]
    private var bottomEnd: [Int] = [30, 31, 32, 33, 34, 35]
    private var leftEnd: [Int] = [0, 6, 12, 18, 24, 30]
    private var rightEnd: [Int] = [5, 11, 17, 23, 29, 35]
    
    private var indexArray: [Int] = []
    private var answerArray: [Int] = []
    private var optionArray: [Game] = []
    private var uniques = Set<UInt32>()
    
    private var sum = 0
    
    private var squareDirection: GameDirection = .idle{
        didSet{
            DispatchQueue.main.async {
                self.didMove()
            }
        }
    }
    private var lastDirection: GameDirection = .idle
    
    private var gameState: GameState = .playing
    
    
    private var timer = Timer()
    private var seconds = 0
    private var minutes = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGameUI()
        generateRandomIndex()
        initTimer()
        initializeMotionDetection()
        gameCollectionView.reloadData()
    }
    
    //MARK:- Game UI
    func setGameUI(){
        //        self.gameCollectionView.layer.cornerRadius = 5
        //        self.gameCollectionView.backgroundColor = .white.withAlphaComponent(0.1)
    }
    
    //MARK:- Core Motion
    func initializeMotionDetection(){
        if motionManager.isAccelerometerAvailable {
            let queue = OperationQueue()
            
            motionManager.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xTrueNorthZVertical, to: queue) { (data, error) in
                
                guard let motionData = data else { return }
                
                if motionData.gravity.x <= -0.3{
                    //Left
                    self.squareDirection = .left
                    return
                }else if motionData.gravity.x >= 0.3{
                    //Right
                    self.squareDirection = .right
                    return
                }
                
                if motionData.gravity.y <= -0.8{
                    //Down
                    self.squareDirection = .down
                    return
                }else if motionData.gravity.y >= -0.4{
                    //Up
                    self.squareDirection = .up
                    return
                }
            }
        } else {
            print("Accelerometer is not available")
        }
    }
    
    //MARK:- Random numbers and index
    //Generate random numbers in a range
    func generateRandomIndex(){
        indexArray.removeAll()
        uniques.removeAll()
        indexArray = Array(0..<4).map { _ in generateUniqueInt(range: 1..<36) }
    }
    
    //Generate unique integer
    func generateUniqueInt(range: Range<Int>) -> Int {
        let random = Int.random(in: 1..<36)
        
        if !uniques.contains(UInt32(random)) {
            uniques.insert(UInt32(random))
            return random
        } else {
            return generateUniqueInt(range: range)
        }
    }
    
    //MARK:- Timer
    func initTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(SGGameViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds < 1 && minutes == 0{
            timerLabel.text = "Time Out"
            deinitTimer()
            timeOut()
        } else if seconds < 1 {
            seconds = 60
            minutes -= 1
        }else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let seconds = Int(time) % 60
        return String(format:"%1i:%02i", minutes, seconds)
    }
    
    func deinitTimer(){
        timer.invalidate()
    }
    
    //MARK:- Time out
    func timeOut(){
        if let targetVC = SGStoryboards.main.instantiateViewController(identifier: "SGGameAlertViewController") as? SGGameAlertViewController{
            targetVC.delegate = self
            targetVC.modalPresentationStyle = .overFullScreen
            targetVC.gameState = .over
            self.present(targetVC, animated: false) {}
        }
    }
    
    //MARK:- Reset Game
    func reset(){
        seconds = 0
        minutes = 1
        sum = 0
        indexArray.removeAll()
        answerArray.removeAll()
        optionArray.removeAll()
        uniques.removeAll()
        gameState = .playing
        squareDirection = .idle
        lastDirection = .idle
        timerLabel.text = ""
        questionLabel.text = ""
        generateRandomIndex()
        initTimer()
        gameCollectionView.reloadData()
    }
    
    //MARK:- Sound
    func playSound(){
        let systemSoundID: SystemSoundID = 1004
        // to play sound
        AudioServicesPlaySystemSound (systemSoundID)
    }
    
    //MARK:- Square - didMove
    func didMove(){
        switch squareDirection{
        case .up:
            if !topEnd.contains(currentIndex) && lastDirection != .up{
                currentIndex -= 6
            }else{
                return
            }
        case .down:
            if !bottomEnd.contains(currentIndex) && lastDirection != .down{
                currentIndex += 6
            }else{
                return
            }
        case .left:
            if !leftEnd.contains(currentIndex) && lastDirection != .left{
                currentIndex -= 1
            }else{
                return
            }
        case .right:
            if !rightEnd.contains(currentIndex) && lastDirection != .right{
                currentIndex += 1
            }else{
                return
            }
        case .idle:
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2 , execute: {
            self.lastDirection = .idle
        })
        
        lastDirection = squareDirection
        gameCollectionView.reloadData()
        
    }
    
}

extension SGGameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 36
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SGGameCollectionViewCell", for: indexPath) as? SGGameCollectionViewCell{
            
            //Game square
            //Checks for the position of game square
            if indexPath.item == currentIndex{
                cell.squareView.backgroundColor = .white
                cell.numberLabel.text = ""
            }
            
            if gameState == .playing{
                //Game index
                //Check for current index in random index array
                if indexArray.contains(indexPath.item){
                    cell.numberLabel.text = "\(indexPath.item)"
                    
                    if indexPath.item == currentIndex{
                        cell.squareView.backgroundColor = .white
                    }else{
                        cell.squareView.backgroundColor = .white.withAlphaComponent(0.4)
                    }
                    
                }else if indexPath.item != currentIndex{
                    cell.numberLabel.text = ""
                    cell.squareView.backgroundColor = .clear
                }
            }else{
                
                if let index = optionArray.firstIndex(where: { (item) -> Bool in
                    return item.index == indexPath.item
                }){
                    cell.numberLabel.text = "\(optionArray[index].value ?? 0)"
                    if indexPath.item == currentIndex{
                        cell.squareView.backgroundColor = .white
                    }else{
                        cell.squareView.backgroundColor = .white.withAlphaComponent(0.4)
                    }
                }else if indexPath.item != currentIndex{
                    cell.numberLabel.text = ""
                    cell.squareView.backgroundColor = .clear
                }
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
        
        if gameState == .playing{
            if indexArray.contains(indexPath.item) && currentIndex == indexPath.item{
                playSound()
                
                //Add selected number
                answerArray.append(indexPath.item)
                
                //Remove selected number
                if let index = indexArray.firstIndex(of: indexPath.item){
                    indexArray.remove(at: index)
                }
                
                generateRandomIndex()
                
                if answerArray.count == 5 {
                    questionLabel.text = "Sum of all selected number ?"
                    gameState = .question
                    currentIndex = 0
                    
                    //Sum of selected numbers
                    answerArray.forEach { value in
                        sum += value
                    }
                    
                    for index in 0..<3{
                        optionArray.append(Game(value: generateUniqueInt(range: 5..<175), index: indexArray[index]))
                    }
                    optionArray.append(Game(value: sum, index: 3))
                    
                    optionArray.shuffle()
                }
                
                gameCollectionView.reloadData()
                
            }
        }else{
            //Stop timer
            deinitTimer()
            
            if let targetVC = SGStoryboards.main.instantiateViewController(identifier: "SGGameAlertViewController") as? SGGameAlertViewController{
                targetVC.delegate = self
                targetVC.modalPresentationStyle = .overFullScreen
                
                if let index = optionArray.firstIndex(where: { (item) -> Bool in
                    return item.index == indexPath.item
                }){
                    if sum == optionArray[index].value{
                        targetVC.gameState = .won
                    }else{
                        targetVC.gameState = .over
                    }
                }else{
                    targetVC.gameState = .over
                }
                
                self.present(targetVC, animated: false) {}
            }
            
        }
    }
}

extension SGGameViewController: GameAlertProtocol{
    func retry() {
        reset()
    }
    
    func level() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
