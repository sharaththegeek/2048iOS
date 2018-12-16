//
//  EndViewController.swift
//  2048- The Game
//
//  Created by Sharath on 10/12/18.
//  Copyright © 2018 Sharath. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {

    @IBOutlet weak var ResultMessage: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    var result: Bool!
    var score: Int! = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        displayResult()
     
        // Do any additional setup after loading the view.
    }
    @IBAction func unWindBack(unwindSegue: UIStoryboardSegue){
        
    }
    func displayResult(){
        if result == true {
            ResultMessage.text = "Congratulations!"
            continueButton.setTitle("Keep going", for: .normal)
            newGameButton.setTitle("New Game!", for: .normal)
            continueButton.isUserInteractionEnabled = true
        }
        if result == false {
            ResultMessage.text = "Game Over!"
            continueButton.setTitle("", for: .normal)
            newGameButton.setTitle("Retry!", for: .normal)
            continueButton.isUserInteractionEnabled = false
        }
        ScoreLabel.text = "\(score!)"
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
