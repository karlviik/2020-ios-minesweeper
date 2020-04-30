//
//  MinesweeperGame.swift
//  iti0213-2019s-hw3
//
//  Created by Karl on 1/27/1399 AP.
//  Copyright © 1399 kaviik. All rights reserved.
//

import Foundation


class MinesweeperGame {
    
    private var x: Int!
    private var y: Int!
    private var bombCount: Int!
    private var gameBoard: Array<Array<MinesweeperGameTile>> = Array()
    private var gameStarted = false
    private var gameOver = false
    private var gameWon = false
    private var unrevealedNonBombTiles: Int!
    private var playerBombCount: Int!
    
    public init(x: Int, y: Int, bombPercent: Int) {
        self.x = x
        self.y = y
        self.bombCount = x * y * bombPercent / 100
        self.unrevealedNonBombTiles = x * y - self.bombCount
        self.playerBombCount = bombCount
    }
    
    private func generate(safeX: Int, safeY: Int) {
        if gameStarted {
            return
        }
        let size = x * y
        var tiles = (0..<size).map {
            return MinesweeperGameTile(content: Int($0) < self.bombCount ? -1 : 0)
        }
        
        // array of safe locations in a flat array, only coordinates that are on the map
        var safeLocations = Array<Int>()
        for cx in (-1)...1 {
            for cy in (-1)...1 {
                let nx = safeX + cx
                let ny = safeY + cy
                if 0 <= nx && nx < x && 0 <= ny && ny < y {
                    safeLocations.append(safeY * x + safeX)
                }
            }
        }
        
        // some shuffling or something
        let end = size - safeLocations.count
        for i in 0..<end {
            // Fisher-Yates shuffle algorithm
            let j = arc4random_uniform(UInt32(end - i)) + UInt32(i)
            if i != j {
                let a = tiles[Int(i)];
                let b = tiles[Int(j)];
                tiles[Int(i)] = b;
                tiles[Int(j)] = a;
            }
        }
        
        // idk what this is supposed to do
        var index = Int(size - 1)
        for location in safeLocations {
            let a = tiles[location];
            let b = tiles[index];
            tiles[location] = b;
            tiles[index] = a;
            index -= 1
        }
        
        // actually convert all of it into format used by the class
        gameBoard = Array()
        for i in 0..<y {
            var gameList : Array<MinesweeperGameTile> = Array()
            for j in 0..<x {
                gameList.append(tiles[i * x + j])
            }
            gameBoard.append(gameList)
        }
        
        // do the thing where you do the number counting for each bomb
        for i in 0..<y {
            for j in 0..<x {
                if gameBoard[i][j].content == -1 {
                    addToNeighbours(xo: j, yo: i)
                }
            }
        }
        gameStarted = true
    }
    
    private func addToNeighbours(xo: Int, yo: Int) {
        for cx in -1...1 {
            for cy in -1...1 {
                if cy != 0 || cx != 0 {
                    let nx = xo + cx
                    let ny = yo + cy
                    if 0 <= nx && nx < x && 0 <= ny && ny < y && gameBoard[ny][nx].content >= 0 {
                        gameBoard[ny][nx].content = gameBoard[ny][nx].content + 1
                    }
                }
            }
        }
    }
    
    func open(x: Int, y: Int) {
        if gameOver {
            return
        }
        if !gameStarted {
            generate(safeX: x, safeY: y)
            gameStarted = true
        }
        let tile = gameBoard[y][x]
        if tile.isOpened || tile.isFlagged {
            return
        }
        if tile.content == -1 {
            print("first")
            revealMap()
            gameOver = true
            tile.isOpened = true
        } else if tile.content == 0 {
            print("second")
            openNeighbours(x: x, y: y)
        } else {
            print("third")
            tile.isOpened = true
            unrevealedNonBombTiles -= 1
        }
        if unrevealedNonBombTiles == 0 {
            gameOver = true
            gameWon = true
            revealMap()
        }
        gameBoard[y][x] = tile
        print(gameBoard[y][x].isOpened)
    }
    
    private func openNeighbours(x: Int, y: Int) {
        let tile = gameBoard[y][x]
        if !tile.isOpened {
            tile.isOpened = true
            unrevealedNonBombTiles -= 1
            if tile.content == 0 {
                for cx in -1...1 {
                    for cy in -1...1 {
                        if (cy != 0 || cx != 0) {
                            let nx = x + cx
                            let ny = y + cy
                            if 0 <= nx && nx < self.x && 0 <= ny && ny < self.y {
                                openNeighbours(x: nx, y: ny)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func revealMap() {
        for y in 0..<y {
            for x in 0..<x {
                gameBoard[y][x].isRevealed = true
            }
        }
    }
    
    func toggleFlag(x: Int, y: Int) {
        if gameOver || !gameStarted {
            return
        }
        let tile = gameBoard[y][x]
        if tile.isFlagged {
            playerBombCount += 1
        } else {
            playerBombCount -= 1
        }
        tile.isFlagged = !tile.isFlagged
    }
    
    func gameFinished() -> Bool {
        return gameOver
    }
    
    func gameWonByPlayer() -> Bool {
        return gameOver && gameWon
    }
    
    func getPlayerBombCount() -> Int {
        return playerBombCount
    }
    
    func getGameField() -> Array<Array<MinesweeperGameTile>> {
        let thing = gameBoard
        return thing
    }
    
    func hasGameStarted() -> Bool {
        return gameStarted
    }
}
