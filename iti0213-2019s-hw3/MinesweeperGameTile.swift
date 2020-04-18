//
//  MinesweeperGameTile.swift
//  iti0213-2019s-hw3
//
//  Created by Karl on 1/27/1399 AP.
//  Copyright © 1399 kaviik. All rights reserved.
//

import Foundation

class MinesweeperGameTile {
    var isFlagged = false
    var isOpened = false
    var isRevealed = false
    var content : Int = 0
    
    init(content: Int) {
        self.content = content
    }
}
