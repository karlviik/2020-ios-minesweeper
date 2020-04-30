//
//  UiTileView.swift
//  iti0213-2019s-hw3
//
//  Created by Karl on 1/26/1399 AP.
//  Copyright © 1399 kaviik. All rights reserved.
//

import UIKit

// makes it previewable
@IBDesignable
class UITileView: UIView {
    
    @IBInspectable
    var hasStarted : Bool = false {didSet {setNeedsDisplay()}}
    // line for flagged bomb in case game over and was not bomb
    @IBInspectable
    var lineWidth : Int = 3 {didSet {setNeedsDisplay()}}
    
    @IBInspectable
    var isOpened : Bool = false {didSet {setNeedsDisplay()}}
    
    // -1 means it is bomb, 0 leaves it empty, 1-8 shows numbers of neighbours.
    @IBInspectable
    var content : Int = 0 {didSet {setNeedsDisplay()}}
    
    // if displays a flag on it and is not clickable
    @IBInspectable
    var isFlagged : Bool = false {didSet {setNeedsDisplay()}}
    
    // for when showing game end state
    @IBInspectable
    var isRevealed : Bool = false {didSet {setNeedsDisplay()}}
    
    @IBInspectable
    var colorNotStartedGame: UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorClosedTile: UIColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorOpenedTile: UIColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorCrossedBomb: UIColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1) {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorsListNumbers : Array<UIColor> = [UIColor.red, UIColor.blue, UIColor.orange, UIColor.green, UIColor.yellow, UIColor.gray, UIColor.purple, UIColor.black] {didSet {setNeedsDisplay()}}
    
    var flagIcon : String = "🚩"  {didSet {setNeedsDisplay()}}
    var bombIcon : String = "💣"  {didSet {setNeedsDisplay()}}
    var explosionIcon : String = "💥"  {didSet {setNeedsDisplay()}}
    var fontSize : Int = 18 {didSet {setNeedsDisplay()}}
    
    // pos
    @IBInspectable
    var positionX: Int = 0
    @IBInspectable
    var positionY: Int = 0
    
    private var viewUpperLeftCorner: CGPoint {return CGPoint(x: 0, y: 0)}
    private var viewUpperRightCorner: CGPoint {return CGPoint(x: bounds.maxX, y: 0)}
    private var viewLowerRightCorner: CGPoint {return CGPoint(x: bounds.maxX, y: bounds.maxY)}
    private var viewLowerLeftCorner: CGPoint {return CGPoint(x: 0, y: bounds.maxY)}
    private var height: CGFloat {return CGFloat(abs(bounds.maxY - bounds.minY))}
    private var width: CGFloat {return CGFloat(abs(bounds.maxX - bounds.minX))}

    private var viewMidPoint: CGPoint {return CGPoint(x: bounds.midX, y: bounds.midY)}

    override func draw(_ rect: CGRect) {
        let square = pathForSquare(upperLeft: viewUpperLeftCorner, upperRight: viewUpperRightCorner, lowerRight: viewLowerRightCorner, lowerLeft: viewLowerLeftCorner, lineWidth: lineWidth)
        if !hasStarted {
            colorNotStartedGame.set()
            square.stroke()
            square.fill()
            return
        }
        if isOpened {
            colorOpenedTile.set()
            square.stroke()
            square.fill()
            // if is bomb
            if content < 0 {
                drawText(text : explosionIcon, rect: rect)
            } else if content > 0 {
                colorsListNumbers[content - 1].set()
                drawText(text: "\(content)", rect: rect)
//                number.stroke()
            }
        } else {
            // not opened
            // if game is over and tile was either flagged not bomb or unflagged bomb
            if isRevealed && (!isFlagged && content == -1 || isFlagged && content != -1) {
                colorOpenedTile.set()
                square.stroke()
                square.fill()
                drawText(text : bombIcon, rect: rect)
                // if is flagged therefore not bomb
                if isFlagged {
                    colorCrossedBomb.set()
                    let cross = pathForCross(firstLineStart: viewUpperLeftCorner, firstLineEnd: viewLowerRightCorner, secondLineStart: viewUpperRightCorner, secondLineEnd: viewLowerLeftCorner, lineWidth: lineWidth)
                    cross.stroke()
                }
            } else {
                colorClosedTile.set()
                square.stroke()
                square.fill()
                if isFlagged {
                    drawText(text : flagIcon, rect: rect)
                }
            }
        }

    }
    
    private func pathForCross(firstLineStart: CGPoint, firstLineEnd: CGPoint, secondLineStart: CGPoint,  secondLineEnd: CGPoint, lineWidth: Int) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: firstLineStart)
        path.addLine(to: firstLineEnd)
        path.move(to: secondLineStart)
        path.addLine(to: secondLineEnd)
        path.lineWidth = CGFloat(lineWidth)
        return path
        
    }
    
    private func pathForSquare(upperLeft: CGPoint, upperRight: CGPoint, lowerRight: CGPoint, lowerLeft: CGPoint, lineWidth: Int) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: upperLeft)
        path.addLine(to: upperRight)
        path.addLine(to: lowerRight)
        path.addLine(to: lowerLeft)
        path.addLine(to: upperLeft)
        path.lineWidth = CGFloat(lineWidth)
        return path
    }
    
    private func drawText(text: String, rect: CGRect) -> Void {
        let convertedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont(name: "Arial", size: CGFloat(self.fontSize))!])
        let textBounds = convertedText.size()
        let adjustedPoint = CGPoint(x: viewMidPoint.x - textBounds.width / 2, y: viewMidPoint.y - textBounds.height / 2)
        convertedText.draw(at: adjustedPoint)
    }
}
