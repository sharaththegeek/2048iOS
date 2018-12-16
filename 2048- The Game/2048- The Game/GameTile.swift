//
//  GameTile.swift
//  2048- The Game
//
//  Created by Sharath on 07/12/18.
//  Copyright © 2018 Sharath. All rights reserved.
//

import Foundation
import UIKit
struct Tile{
    var number: String
    var color: String
}

let emptyTile=hexStringToUIColor("DED1C0")
let notWhite=hexStringToUIColor("A29789")
let n2=hexStringToUIColor("FAE7D7")
let n4=hexStringToUIColor("FFE4CC")
let n8=hexStringToUIColor("FFC37C")
let n16=hexStringToUIColor("FF9D2B")
let n32=hexStringToUIColor("FF8B00")
let n64=hexStringToUIColor("FF6C00")
let n128=hexStringToUIColor("D6BB9F")
let n256=hexStringToUIColor("BEAC91")
let n512=hexStringToUIColor("FFE098")
let n1024=hexStringToUIColor("EAC572")
let n2048=hexStringToUIColor("FFC441")
let n4096=hexStringToUIColor("FFB000")

func hexStringToUIColor (_ hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

struct SaveGame: Codable {
    var save: Bool
    var saveState: [Int]
    var highs: Int
    var saveScore: Int
    var loser: Bool
}
var sampleGame = Array(repeating: 0, count: 16)
var savedGame = SaveGame(save: false, saveState: sampleGame, highs: 0, saveScore: 0, loser: false)
let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let archiveURL = documentsDirectory.appendingPathComponent("highs_test").appendingPathExtension("plist")

let propertyListEncoder = PropertyListEncoder()
let propertyListDecoder = PropertyListDecoder()
