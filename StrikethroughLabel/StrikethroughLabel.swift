//
//  StrikethroughLabel.swift
//  StrikethroughLabel
//
//  Created by Charles Prado on 07/04/20.
//  Copyright © 2020 Charles Prado. All rights reserved.
//

import UIKit

open class StrikethroughLabel: UILabel {
    
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
            let lineMaxX = maxXForLine(withText: attributedText,
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

        let lines = self.lines(forLabel: self) ?? []
        let numberOfLines = lines.count

        for line in 1...numberOfLines {
            strikeThroughText(line: line, inLines: lines)
        }
    }

    private func lines(forLabel: UILabel) -> [String]? {

        guard let text = text, let font = font else { return nil }

        let attStr = NSMutableAttributedString(string: text)
        attStr.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: attStr.length))

        let frameSetter = CTFramesetterCreateWithAttributedString(attStr as CFAttributedString)
        let path = CGMutablePath()

        let size = sizeThatFits(CGSize(width: self.frame.width, height: .greatestFiniteMagnitude))
        path.addRect(CGRect(x: 0, y: 0, width: size.width, height: size.height), transform: .identity)

        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, attStr.length), path, nil)
        guard let lines = CTFrameGetLines(frame) as? [Any] else { return nil }

        var linesArray: [String] = []

        for line in lines {
            let lineRef = line as! CTLine
            let lineRange = CTLineGetStringRange(lineRef)
            let range = NSRange(location: lineRange.location, length: lineRange.length)
            let lineString = (text as NSString).substring(with: range)
            linesArray.append(lineString)
        }
        return linesArray
    }

    private func maxXForLine(withText text: NSAttributedString, labelWidth: CGFloat) -> CGFloat {
        let labelSize = CGSize(width: labelWidth, height: .infinity)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: labelSize)
        let textStorage = NSTextStorage(attributedString: text)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.maximumNumberOfLines = 0

        let lastGlyphIndex = layoutManager.glyphIndexForCharacter(at: text.length - 1)
        let lastLineFragmentRect = layoutManager.lineFragmentUsedRect(forGlyphAt: lastGlyphIndex,
                effectiveRange: nil)

        return lastLineFragmentRect.maxX
    }
}
