//
//  UILabel+Extensions.swift
//  StrikethroughLabel
//
//  Created by Charles Prado on 07/04/20.
//  Copyright © 2020 Charles Prado. All rights reserved.
//

import UIKit

extension UILabel {
    var lines: [String]? {

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

    public func maxXForLine(withText text: NSAttributedString, labelWidth: CGFloat) -> CGFloat {
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

