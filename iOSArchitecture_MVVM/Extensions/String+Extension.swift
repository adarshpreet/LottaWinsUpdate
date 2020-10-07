//
//  String+RUI.swift
//  FarmX
//
//  Created by Office on 4/23/18.
//  Copyright © 2018 Sumit Jain. All rights reserved.
//

import UIKit

extension String {
    func sizeOfString (width: CGFloat = CGFloat.greatestFiniteMagnitude, font: UIFont, height: CGFloat = CGFloat.greatestFiniteMagnitude, drawingOption: NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin) -> CGSize {
        return (self as NSString).boundingRect(with: CGSize(width: width, height: height), options: drawingOption, attributes: [NSAttributedString.Key.font: font], context: nil).size
    }
    func numberOfLinesForString(size: CGSize, font: UIFont) -> Int {
        let textStorage = NSTextStorage(string: self, attributes: [NSAttributedString.Key.font: font])
        let textContainer = NSTextContainer(size: size)
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.maximumNumberOfLines = 0
        textContainer.lineFragmentPadding = 0
        let layoutManager = NSLayoutManager()
        layoutManager.textStorage = textStorage
        layoutManager.addTextContainer(textContainer)
        var numberOfLines = 0
        var index = 0
        //var lineRange: NSRange = NSMakeRange(0, 0)
        var lineRange: NSRange = NSRange.init(location: 0, length: 0)
        while index < layoutManager.numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    var stringByDeletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    var stringByDeletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    func stringByAppendingPathExtension(ext: String) -> String? {
        let nsSt = self as NSString
        return nsSt.appendingPathExtension(ext)
    }
    func trimSpaces() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    func toBool() -> Bool {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return false
        }
    }
    public func isValidEmail() -> Bool {
        let stricterFilterString: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
        return emailTest.evaluate(with: self)
    }
    public func isValidPincode() -> Bool {
        let stricterFilterString: String = "[1-9][0-9]{5}"
        let pincodeTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
        return pincodeTest.evaluate(with: self)
    }
}

extension String {
    
    func convertToDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        }
        return nil
    }

    /// Handles 10 or 11 digit phone numbers
    ///
    /// - Returns: formatted phone number or original value
    public func toPhoneNumber() -> String {
        let digits = self.digitsOnly
        if digits.count == 10 {
            return digits.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1)-$2-$3", options: .regularExpression, range: nil)
        }
        else if digits.count == 11 {
            return digits.replacingOccurrences(of: "(\\d{1})(\\d{3})(\\d{3})(\\d+)", with: "$1($2)-$3-$4", options: .regularExpression, range: nil)
        }
        else {
            return self
        }
    }
    
    static func format(strings: [String],
                          boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                          boldColor: UIColor = UIColor.blue,
                          inString string: String,
                          font: UIFont = UIFont.systemFont(ofSize: 14),
                          color: UIColor = UIColor.black) -> NSAttributedString {
           let attributedString =
               NSMutableAttributedString(string: string,
                                         attributes: [
                                           NSAttributedString.Key.font: font,
                                           NSAttributedString.Key.foregroundColor: color])
           let boldFontAttribute = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: boldColor]
           for bold in strings {
               attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
           }
           return attributedString
       }

}

extension StringProtocol {

    /// Returns the string with only [0-9], all other characters are filtered out
    var digitsOnly: String {
        return String(filter(("0"..."9").contains))
    }

}

extension NSString {
    
    func addBoldText(boldPartsOfString: [String], font: UIFont!, boldFont: UIFont!, boldFontcolor: UIColor) -> NSAttributedString {
        let nonBoldFontAttribute = [NSAttributedString.Key.font:font ?? UIFont.systemFont(ofSize: 22)]
        let boldFontAttribute = [NSAttributedString.Key.font:boldFont ?? UIFont.systemFont(ofSize: 11)]
        let colorAttribute = [NSAttributedString.Key.foregroundColor:boldFontcolor]
        
        let boldString = NSMutableAttributedString(string: self as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: self.range(of: boldPartsOfString[i] as String))
            boldString.addAttributes(colorAttribute, range: self.range(of: boldPartsOfString[i] as String))
        }
        return boldString
    }
    
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}


extension String {
    
    
    func UTCToLocal(withInputFormat inputFormat: String, withOutputFormat outputFormat:String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let dt = dateFormatter.date(from: self) else {return ""}
        //dt = toLocalTime(dt)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: dt)
    }
    
    //MARK:- Convert Local To UTC Date by passing date formats value
    func localToUTC(incomingFormat: String, outGoingFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = outGoingFormat
        
        return dateFormatter.string(from: dt ?? Date())
    }
    
    func localDate(date:String) -> String {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = DateEnum.yyyyMMDD.rawValue
       dateFormatter.calendar = NSCalendar.current
       let dt = dateFormatter.date(from: date)
       dateFormatter.timeZone = TimeZone.current
       dateFormatter.dateFormat = "HH:mm"
       return dateFormatter.string(from: dt!)
    }
       

    
}
