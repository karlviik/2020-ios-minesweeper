//
//  ViewController.swift
//  iti0213-2019s-hw3
//
//  Created by Karl on 1/26/1399 AP.
//  Copyright © 1399 kaviik. All rights reserved.
//

import UIKit

class MinesweeperViewController: UIViewController {
    
    private let SIZE = 30
    private var game : MinesweeperGame?
    private var boardHeight: CGFloat {return gameBoard.bounds.height}
    private var boardWidth: CGFloat {return gameBoard.bounds.width}
    private var x : Int?
    private var y : Int?
    private var timer : Timer?
    private var timerTime = 0

    @IBOutlet weak var mainView: UIStackView!
    
    @IBOutlet weak var buttonView: UIStackView!
    @IBOutlet weak var topView: UIStackView!
    @IBOutlet weak var gameBoard: UIStackView!

    @IBOutlet weak var gameBombCounter: UILabel!
    
    @IBOutlet weak var gameTimeCounter: UILabel!
    
    @IBAction func startNewGame(_ sender: UIButton) {
        var bombPercent : Int
        switch sender.tag {
        case 1:
            bombPercent = 10
        case 2:
            bombPercent = 20
        case 3:
            bombPercent = 30
        default:
            return
        }
        game = MinesweeperGame(x: x!, y: y!, bombPercent: bombPercent)
        if let tim = timer {
            tim.invalidate()
        }
        timerTime = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.doTimerUpdate), userInfo: nil, repeats: true)
        cleanGameViews()

    }
    
    @objc func doTimerUpdate() {
        timerTime += 1
        gameTimeCounter.text = "\(timerTime)"
    }
    
    private func cleanGameViews() {
        gameBombCounter.text = "\(game!.getPlayerBombCount())"
        gameTimeCounter.text = "0"
        for stack in gameBoard.arrangedSubviews {
            let stackView = stack as! UIStackView
            for tile in stackView.arrangedSubviews {
                let tileView = tile as! UITileView
                tileView.content = 0
                tileView.isFlagged = false
                tileView.isRevealed = false
                tileView.isOpened = false
                tileView.hasStarted = true
            }
        }
    }
    
    private func buildGameBoard() {

        x = Int(round(Double(min(boardHeight, boardWidth) - 4) / Double(SIZE + 4)))
        y = Int(round(Double(max(boardHeight, boardWidth) - 4) / Double(SIZE + 4)))

        
        
        for i in 0..<y! {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.alignment = .fill
            rowStack.distribution = .fillEqually
            rowStack.spacing = 4.0
            gameBoard.addArrangedSubview(rowStack)

            for j in 0..<x! {
                let tile = UITileView()
                tile.bounds.size = CGSize(width: SIZE, height: SIZE)
                tile.positionY = i
                tile.positionX = j
                tile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gesture:))))
                tile.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.handlePress(gesture:))))
                rowStack.addArrangedSubview(tile)
            }
        }
        print("finished building game board")
        print(boardHeight)
        print(boardWidth)

        print(gameBoard.arrangedSubviews.count)
        print(gameBoard.arrangedSubviews[0].bounds.height)
        print(gameBoard.arrangedSubviews[0].bounds.width)
        let test = gameBoard.arrangedSubviews[0] as! UIStackView
        print(test.arrangedSubviews.count)
        
    }
    
    private func updateGameViews() {
        if let _ = game, let board = game?.getGameField() {
            gameBombCounter.text = "\(game!.getPlayerBombCount())"
            
            
            for stack in gameBoard.arrangedSubviews {
                let stackView = stack as! UIStackView
                for tile in stackView.arrangedSubviews {
                    let tileView = tile as! UITileView
                    let x = tileView.positionX
                    let y = tileView.positionY
                    let brainTile = board[y][x]
                    tileView.content = brainTile.content
                    tileView.isFlagged = brainTile.isFlagged
                    tileView.isRevealed = brainTile.isRevealed
                    tileView.isOpened = brainTile.isOpened

                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildGameBoard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrientationUI), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer){
        switch gesture.state {
        case .ended:
            // game tile was pressed
            if let view = gesture.view as? UITileView, let _ = game {
                print("Letting it open")
                game!.open(x: view.positionX, y: view.positionY)
                updateGameViews()
                if (game!.gameFinished()) {
                    timer?.invalidate()
                }
            }
        default:
            break
        }
    }

    @objc func handlePress(gesture: UILongPressGestureRecognizer){
        switch gesture.state {
        case .ended:
            // game tile was pressed
            if let view = gesture.view as? UITileView, let g = game {
                if game!.hasGameStarted() {
                g.toggleFlag(x: view.positionX, y: view.positionY)
                updateGameViews()
                }
            }
        default:
            break
        }
    }
    
    
    private func handleUiUpdate(landscape: Bool) {
        gameBoard.translatesAutoresizingMaskIntoConstraints = false
        if landscape {
            mainView.axis = .horizontal
            topView.axis = .vertical
            buttonView.axis = .vertical
            gameBoard.axis = .horizontal
            
            for stack in gameBoard.arrangedSubviews {
                let stackView = stack as! UIStackView
                stackView.axis = .vertical
            }
        } else {
            mainView.axis = .vertical
            topView.axis = .horizontal
            buttonView.axis = .horizontal
            gameBoard.axis = .vertical
            
            for stack in gameBoard.arrangedSubviews {
                let stackView = stack as! UIStackView
                stackView.axis = .horizontal
            }
        }
    }
    
    
    @objc func updateOrientationUI(){
        var orientationText = "Orient: "
        switch UIDevice.current.orientation {
        case .faceUp:
            orientationText += "faceUp"
        case .faceDown:
            orientationText += "faceDown"
        case .landscapeLeft:
            orientationText += "landscapeLeft"
            handleUiUpdate(landscape: true)
        case .landscapeRight:
            orientationText += "landscapeRight"
            handleUiUpdate(landscape: true)
        case .portrait:
            orientationText += "portrait"
            handleUiUpdate(landscape: false)
        case .portraitUpsideDown:
            orientationText += "portraitUpsideDown"
        case .unknown:
            orientationText += "unknown"
        default:
            orientationText += "new"
        }
        print("updateOrientationUI \(orientationText)")
    }
}

