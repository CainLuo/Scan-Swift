//
//  String+Extensions.swift
//  CLExtensions
//
//  Created by CainLuo on 2019/9/14.
//  Copyright © 2019年 CainLuo. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    public func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    public func removeSpace() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    public func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    public func convertToAttributedStringWith(lineSpace: CGFloat) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = lineSpace // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
}

// MARK: - String Regular
extension String {
    public var isValidEmail: Bool {
        //http://emailregex.com/
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    public var isContainsLetters: Bool {
        let letters = CharacterSet.letters
        return rangeOfCharacter(from: letters) != nil
    }
    
    public var isAlphanumeric: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[a-zA-Z0-9]+").evaluate(with: self)
    }
    
    public var isNumber: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[0-9]+").evaluate(with: self)
    }
    
    public var isAlphabet: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[a-zA-Z]+").evaluate(with: self)
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

extension Optional where Wrapped == String {
    public var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
