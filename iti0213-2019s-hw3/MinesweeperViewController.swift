//
//  ViewController.swift
//  iti0213-2019s-hw3
//
//  Created by Karl on 1/26/1399 AP.
//  Copyright © 1399 kaviik. All rights reserved.
//

import UIKit

class MinesweeperViewController: UIViewController {
    
    private let BASE_SIZE = 30
    private var game : MinesweeperGame?
    private var boardHeight: CGFloat {return gameBoard.bounds.height}
    private var boardWidth: CGFloat {return gameBoard.bounds.width}
    private var x : Int?
    private var y : Int?
    private var timer : Timer?
    private var timerTime = 0
    
    var flagIcon = "🚩"
    var bombIcon = "💣"
    var explosionIcon = "💥"
    var theme: Int = 0
    var bombPercentage: Float = 0.5
    var gameBoardSize: Float = 1

    @IBOutlet weak var mainView: UIStackView!
    
    @IBOutlet weak var buttonView: UIStackView!
    @IBOutlet weak var topView: UIStackView!
    @IBOutlet weak var gameBoard: UIStackView!

    @IBOutlet weak var gameBombCounter: UILabel!
    @IBOutlet weak var gameTimeCounter: UILabel!
    
    @IBAction func resetGame(_ sender: UIButton) {
        startNewGame()
    }
    func startNewGame() {
        let bombPercent = Int(50 * bombPercentage)
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
        let SIZE = Int(Float(BASE_SIZE) * (4.0 - 3 * gameBoardSize))
        let fontSize = Int(14.0 * (4.0 - 3 * gameBoardSize))
        var color : UIColor
        switch theme {
        case 0:
            color = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        case 1:
            color = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        case 2:
            color = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        case 3:
            color = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        default:
            color = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        
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
                tile.fontSize = fontSize
                tile.flagIcon = flagIcon
                tile.bombIcon = bombIcon
                tile.explosionIcon = explosionIcon
                tile.colorOpenedTile = color
                
                tile.bounds.size = CGSize(width: SIZE, height: SIZE)
                tile.positionY = i
                tile.positionX = j
                tile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gesture:))))
                tile.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.handlePress(gesture:))))
                rowStack.addArrangedSubview(tile)
            }
        }
        print("finished building game board")
        
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
        startNewGame()
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrientationUI), name: UIDevice.orientationDidChangeNotification, object: nil)
        updateOrientationUI()
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
            handleUiUpdate(landscape: UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false)
        default:
            orientationText += "new"
        }
        print("updateOrientationUI \(orientationText)")
    }
}

