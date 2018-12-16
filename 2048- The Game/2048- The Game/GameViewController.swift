//
//  ViewController.swift
//  2048- The Game
//
//  Created by Sharath on 07/12/18.
//  Copyright © 2018 Sharath. All rights reserved.
//

import UIKit
import Foundation
class GameViewController: UIViewController {

    @IBOutlet weak var currScoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var MenuButton: UIButton!
    @IBOutlet var numberButtons: [UIButton]!
    @IBAction func GamePressed(_ sender: UIButton) {
        newGame()
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        performMoveLeft(start: 0)
    }
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        performMoveRight(start: 3)
    }
    @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
        performMoveUp(start: 0)
    }
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        performMoveDown(start: 12)
    }
    override func viewWillAppear(_ animated:Bool){
        super.viewWillAppear(animated)
        for button in numberButtons{
            button.isUserInteractionEnabled=false
        }
       
    }
    var winShown = 0
    var gameState = Array(repeating: 0, count: 16)
    var totalScore = 0
    var result = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.restorationIdentifier = "GameViewController"
        if let retrievedHighsData = try? Data(contentsOf: archiveURL), let oldGame = try? propertyListDecoder.decode(SaveGame.self, from: retrievedHighsData) {
            savedGame = oldGame
        }
        newGame()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func prepare(for segue:UIStoryboardSegue, sender:Any?){
        if segue.identifier == "ResultSegue" {
            let resultcontrol = segue.destination as! EndViewController
            resultcontrol.result = result
            resultcontrol.score = totalScore
        }
    }
    @IBAction func unwindtoGame(unwindSegue: UIStoryboardSegue){
        
    }
    let newElement = [2,4]
    var done=0
    func newGame(){
        let hi = savedGame.highs
        highScoreLabel.text = "\(hi)"
       
        if savedGame.save == true && savedGame.loser == false {
            gameState = savedGame.saveState
            var indValue = 0
            while indValue < 16 {
                if gameState[indValue] == -1 {
                    gameState[indValue] = 0
                }
                setButton(indValue, gameState[indValue])
                indValue = indValue + 1
            }
            totalScore = savedGame.saveScore
            currScoreLabel.text = "\(totalScore)"
            savedGame.save = false
        }
        else {
        for button in numberButtons{
            clearButton(button);
        }
        totalScore = 0
        currScoreLabel.text = "\(totalScore)"
        var recur = 0
        while recur < 16 {
            gameState[recur] = 0
            recur = recur + 1
        }
        let index1 = Int.random(in: 1..<16)
        var index2 = Int.random(in: 1..<16)
        while index2 == index1{
            index2 = Int.random(in: 1..<16)
        }
        gameState[index1] = 2
        gameState[index2] = 2
        setButton(index1,2)
        setButton(index2,2)
        savedGame.loser = false
        savedGame.saveState = gameState
        savedGame.saveScore = 0
        let encodedHighs = try? propertyListEncoder.encode(savedGame)
        try? encodedHighs?.write(to: archiveURL, options: .noFileProtection)
        }
    }
    func setButton(_ index:Int,_ number: Int)
    {
        if number==0 || number == -1 {
            numberButtons[index].setTitle("",for: .normal)
            numberButtons[index].backgroundColor=emptyTile
        }
        else{
        numberButtons[index].setTitle("\(number)",for: .normal)
        
        if(number<16){ numberButtons[index].setTitleColor(notWhite,for: .normal)
            numberButtons[index].titleLabel!.font = UIFont(name: "GillSans", size: 48)
    }
        else if number < 128 {
            numberButtons[index].setTitleColor(UIColor.white, for: .normal)
            numberButtons[index].titleLabel!.font = UIFont(name: "GillSans-SemiBold", size: 42)
        }
        else if number < 1024 {
            numberButtons[index].setTitleColor(UIColor.white, for: .normal)
            numberButtons[index].titleLabel!.font = UIFont(name: "GillSans-SemiBold", size: 36)
            }
        else{
            numberButtons[index].setTitleColor(UIColor.white, for: .normal)
            numberButtons[index].titleLabel!.font = UIFont(name: "GillSans-SemiBold", size: 30)
            }
        var ncolor:UIColor!
        switch number{
        case 2:
            ncolor=n2
        case 4:
            ncolor=n4
        case 8:
            ncolor=n8
        case 16:
            ncolor=n16
        case 32:
            ncolor=n32
        case 64:
            ncolor=n64
        case 128:
            ncolor=n128
        case 256:
            ncolor=n256
        case 512:
            ncolor=n512
        case 1024:
            ncolor=n1024
        case 2048:
            ncolor=n2048
        default:
            ncolor=n4096
        }
        numberButtons[index].backgroundColor=ncolor
        }
}
    func sendLost() {
        result = false
        savedGame.loser = true
        var index = 0
        while index < 6 {
            if savedGame.highs < totalScore {
                savedGame.highs = totalScore
            }
            index = index + 1
        }
        savedGame.save = true
        let encodedHighs = try? propertyListEncoder.encode(savedGame)
        try? encodedHighs?.write(to: archiveURL, options: .noFileProtection)
        performSegue(withIdentifier: "ResultSegue", sender: nil)
    }
    func sendWin() {
        result = true
        var index = 0
        while index < 6 {
            if savedGame.highs < totalScore {
                savedGame.highs = totalScore
            }
            index = index + 1
        }
        savedGame.loser = true
        savedGame.save = true
        let encodedHighs = try? propertyListEncoder.encode(savedGame)
        try? encodedHighs?.write(to: archiveURL, options: .noFileProtection)
        performSegue(withIdentifier: "ResultSegue", sender: nil)
    }
    func clearButton(_ button:UIButton)
    {
        button.setTitle("",for: .normal)
        button.backgroundColor=emptyTile
    }
    func createElem() {
        var indValue = 0
        var emptyArray: [Int] = []
        while indValue < 16 {
            if gameState[indValue] == 0 || gameState[indValue] == -1 {
                emptyArray.append(indValue)
            }
            indValue = indValue + 1
        }
        let newIndex = emptyArray.randomElement()!
        let newElem = newElement.randomElement()!
        gameState[newIndex] = newElem
    }
    func endGame(_ score:Int) {
        var indValue = 0
        totalScore = totalScore + score
        currScoreLabel.text = "\(totalScore)"
        while indValue < 16 {
            if gameState[indValue] == -1 {
                gameState[indValue] = 0
            }
            setButton(indValue, gameState[indValue])
            indValue = indValue + 1
        }
        indValue = 0
        while indValue < 16 && winShown == 0{
            if gameState[indValue] == 2048 {
                winShown = 1
                sendWin()
            }
            indValue = indValue + 1
        }
        savedGame.saveState = gameState
        savedGame.saveScore = totalScore
    }
    func checkLost() {
      var lost = 1
      var row = 0
        while row < 16 {
            var inrow = row + 1
            while inrow < (row + 4) {
                if gameState[inrow] == gameState[inrow-1] {
                    lost = 0
                }
                inrow = inrow + 1
            }
            row = row + 4
        }
        row = 3
        while row < 16 {
            var inRow = row - 1
            while inRow > (row - 4) {
                if gameState[inRow] == gameState[inRow+1] {
                    lost = 0
                }
                inRow = inRow - 1
            }
            row = row + 4
        }
        row = 0
        while row < 4 {
                var inRow = row + 4
                while inRow < 16 {
                    if gameState[inRow] == gameState[inRow-4]
                    {
                        lost = 0
                    }
                    inRow = inRow + 4
            }
            row = row + 1
        }
        row = 12
        while row < 16 {
                var inRow = row - 4
                while inRow > -1 {
                    if gameState[inRow] == gameState[inRow+4] {
                        lost = 0
                    }
                    inRow = inRow - 4
        }
        row = row + 1
        }
        row = 0
        while row < 16 {
            if gameState[row] == 0 {
                lost = 0
            }
            row = row + 1
        }
        if lost == 1 {
            sendLost()
        }
    }
    func performMoveLeft(start: Int)
    {
     var row = start
     var moved = 0
     var score = 0
        while row < 16 {
            var inrow = row + 1
            while inrow < (row + 4) {
                if gameState[inrow] != 0 && gameState[inrow] != -1 {
                    if gameState[inrow] == gameState[inrow-1] {
                        gameState[inrow-1] = gameState[inrow] + gameState [inrow-1]
                        gameState[inrow] = -1
                        moved = moved + 1
                        score = score + gameState[inrow-1]
                    }
                    else {
                        var minRow = inrow
                        while minRow > row {
                            if gameState[minRow-1] == 0 || gameState[minRow-1] == -1 {
                                let temp = gameState[minRow]
                                gameState[minRow] = gameState[minRow-1]
                                gameState[minRow-1] = temp
                                moved = moved + 1
                            }
                            else {
                                if gameState[minRow-1] == gameState[minRow] && gameState[minRow+1] == 0 {
                                    gameState[minRow-1] = gameState[minRow] + gameState [minRow-1]
                                    gameState[minRow] = -1
                                    moved = moved + 1
                                    score = score + gameState[minRow-1]
                                }
                                else {
                                    if minRow < (row+3) {
                                    if gameState[minRow+1] == -1 {
                                       gameState[minRow+1] = 0
                                    }
                                    }
                                    break
                                }
                            }
                            minRow = minRow - 1
                        }
                    }
                }
                inrow = inrow + 1
            }
            row = row + 4
        }
        if moved != 0 {
            createElem()
        }
        endGame(score)
        if moved == 0 {
            checkLost()
        }

    }
    func performMoveRight(start:Int) {
        var row = start
        var moved = 0
        var score = 0
        while row < 16 {
            var inRow = row - 1
            while inRow > (row - 4) {
                if gameState[inRow] != 0 && gameState[inRow] != -1 {
                    if gameState[inRow] == gameState[inRow+1] {
                        gameState[inRow+1] = gameState[inRow] + gameState [inRow+1]
                        gameState[inRow] = -1
                        moved = moved + 1
                        score = score + gameState[inRow+1]
                    }
                    else {
                        var minRow = inRow
                        while minRow < row {
                            if gameState[minRow+1] == 0 || gameState[minRow+1] == -1 {
                                let temp = gameState[minRow]
                                gameState[minRow] = gameState[minRow+1]
                                gameState[minRow+1] = temp
                                moved = moved + 1
                            }
                            else {
                                if gameState[minRow+1] == gameState[minRow] && gameState[minRow-1] == 0 {
                                    gameState[minRow+1] = gameState[minRow] + gameState [minRow+1]
                                    gameState[minRow] = -1
                                    moved = moved + 1
                                    score = score + gameState[minRow+1]
                                }
                                else {
                                    if minRow-1 >= row-3 {
                                    if gameState[minRow-1] == -1 {
                                        gameState[minRow-1] = 0
                                    }
                                    }
                                    break
                                }
                            }
                            minRow = minRow + 1
                        }
                    }
                }
                inRow = inRow - 1
            }
            row = row + 4
        }
        if moved != 0 {
             createElem()
        }
        endGame(score)
        if moved == 0 {
            checkLost()
        }

    }
    func performMoveUp(start: Int){
        var row = start
        var moved = 0
        var score = 0
        while row < 4 {
            var inRow = row + 4
            while inRow < 16 {
                if gameState[inRow] != 0 && gameState[inRow] != -1 {
                    if gameState[inRow] == gameState[inRow-4] {
                        gameState[inRow-4] = gameState[inRow] + gameState [inRow-4]
                        gameState[inRow] = -1
                        moved = moved + 1
                        score = score + gameState[inRow-4]
                    }
                    else {
                        var minRow = inRow
                        while minRow > row {
                            if gameState[minRow-4] == 0 || gameState[minRow-4] == -1 {
                                let temp = gameState[minRow]
                                gameState[minRow] = gameState[minRow-4]
                                gameState[minRow-4] = temp
                                moved = moved + 1
                            }
                            else {
                                if gameState[minRow-4] == gameState[minRow] && gameState[minRow+4] == 0 {
                                    gameState[minRow-4] = gameState[minRow] + gameState [minRow-4]
                                    gameState[minRow] = -1
                                    moved = moved + 1
                                    score = score + gameState[minRow-4]
                                }
                                else {
                                    if minRow < (row+12){
                                    if gameState[minRow+4] == -1 {
                                        gameState[minRow+4] = 0
                                    }
                                    }
                                    break
                                }
                            }
                            minRow = minRow - 4
                        }
                    }
                }
               inRow = inRow + 4
            }
            row = row + 1
        }
        if moved != 0 {
            createElem()
        }
        
        endGame(score)
        if moved == 0 {
            checkLost()
        }

    }
    func performMoveDown(start: Int){
        var row = start
        var moved = 0
        var score = 0
        while row < 16 {
            var inRow = row - 4
            while inRow > -1 {
                if gameState[inRow] != 0 && gameState[inRow] != -1 {
                    if gameState[inRow] == gameState[inRow+4] {
                        gameState[inRow+4] = gameState[inRow] + gameState [inRow+4]
                        gameState[inRow] = -1
                        moved = moved + 1
                        score = score + gameState[inRow+4]
                    }
                    else {
                        var minRow = inRow
                        while minRow < row {
                            if gameState[minRow+4] == 0 || gameState[minRow+4] == -1 {
                                let temp = gameState[minRow]
                                gameState[minRow] = gameState[minRow+4]
                                gameState[minRow+4] = temp
                                moved = moved + 1
                            }
                            else {
                                if gameState[minRow+4] == gameState[minRow] && gameState[minRow-4] == 0 {
                                    gameState[minRow+4] = gameState[minRow] + gameState [minRow+4]
                                    gameState[minRow] = -1
                                    moved = moved + 1
                                    score = score + gameState[minRow+4]
                                }
                                else {
                                    if minRow > (row-12){
                                    if gameState[minRow-4] == -1 {
                                        gameState[minRow-4] = 0
                                    }
                                    }
                                    break
                                }
                            }
                            minRow = minRow + 4
                        }
                    }
                }
                inRow = inRow - 4
            }
            row = row + 1
        }
        if moved != 0 {
            createElem()
        }
        endGame(score)
        if moved == 0 {
            checkLost()
        }
    }
}
