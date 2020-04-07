//
//  StrikethroughLabel.swift
//  StrikethroughLabel
//
//  Created by Charles Prado on 07/04/20.
//  Copyright © 2020 Charles Prado. All rights reserved.
//

import UIKit

public class StrikethroughLabel: UILabel {
    private var strikeTextLayers = [CAShapeLayer]()

    public func hideStrikeTextLayer() {
        self.strikeTextLayers.forEach { layer in layer.removeFromSuperlayer() }
    }

    public func showStrikeTextLayer() {
        self.strikeThroughText(duration: 0.0)
    }

    public func strikeThroughText(duration: TimeInterval = 0.3, lineColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) {
        self.strikeTextLayers.forEach { layer in layer.removeFromSuperlayer() }

        func strikeThroughText(line: Int, inLines lines: [String]) {
            let baseYPosition = (font.lineHeight * (CGFloat(line - 1) + 0.5))
            guard baseYPosition < self.frame.height else { return }

            let path = UIBezierPath()
            path.move(to: CGPoint(x: -4, y: baseYPosition))

            let attributedText = NSAttributedString(string: lines[line - 1].trimmingCharacters(in: .whitespaces),
                    attributes: [.font: self.font])
            let lineMaxX = self.maxXForLine(withText: attributedText,
                    labelWidth: self.bounds.width) + 4

            path.addLine(to: CGPoint(x: lineMaxX, y: baseYPosition))

            let shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
            shapeLayer.strokeColor = lineColor.cgColor
            shapeLayer.lineWidth = 1
            shapeLayer.path = path.cgPath

            self.layer.addSublayer(shapeLayer)
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.duration = duration
            shapeLayer.add(animation, forKey: "strikeThroughTextAnimation")

            self.strikeTextLayers.append(shapeLayer)
        }

        let lines = self.lines ?? []
        let numberOfLines = lines.count

        for line in 1...numberOfLines {
            strikeThroughText(line: line, inLines: lines)
        }
    }
}
