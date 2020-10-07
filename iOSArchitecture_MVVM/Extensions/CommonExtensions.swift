import Foundation
import UIKit

public func log<T>(_ object: T?, filename: String = #file, line: Int = #line, funcname: String = #function) {
    #if DEVELOPMENT
        guard let object = object else { return }
        print("***** \(Date()) \(filename.components(separatedBy: "/").last ?? "") (line: \(line)) :: \(funcname) :: \(object)")
    #endif
}

/*
// Disable print for production.
func print(items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEVELOPMENT
    Swift.print(items[0], separator:separator, terminator: terminator)
    #endif
}

func print(items: Any) {
    #if DEVELOPMENT
       Swift.print(items)
    #endif
}
*/

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    class var className: String {
        return String(describing: self)
    }
}

extension UILabel {
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}

extension UITextField {
    
    public var activityIndicator: UIActivityIndicatorView? {
        return self.rightView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    if #available(iOS 13.0, *) {
                        let newActivityIndicator = UIActivityIndicatorView(style: .medium)
                        newActivityIndicator.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                        newActivityIndicator.startAnimating()
                        newActivityIndicator.backgroundColor = UIColor.white
                        self.rightView?.addSubview(newActivityIndicator)
                        let leftViewSize = self.rightView?.frame.size ?? CGSize.zero
                        newActivityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                    } else {
                        // Fallback on earlier versions
                        let newActivityIndicator = UIActivityIndicatorView(style: .white)
                        newActivityIndicator.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                        newActivityIndicator.startAnimating()
                        newActivityIndicator.backgroundColor = UIColor.white
                        self.rightView?.addSubview(newActivityIndicator)
                        let leftViewSize = self.rightView?.frame.size ?? CGSize.zero
                        newActivityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                    }
                } else {
                    activityIndicator?.removeFromSuperview()
                }
            } else {
                activityIndicator?.removeFromSuperview()
            }
        }
    }
    
}

extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}


protocol NIBRegister : class {
    func registerNIB(_ name: String)
}

extension UITableView : NIBRegister {
    
    func registerNIB(_ name: String) {
        self.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
}

extension UICollectionView : NIBRegister {
    
    func registerNIB(_ name: String) {
        self.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
    }
    
    var centerPoint : CGPoint {
        get {
            return CGPoint(x: self.center.x + self.contentOffset.x, y: self.center.y + self.contentOffset.y);
        }
    }

    var centerCellIndexPath: IndexPath? {

        if let centerIndexPath: IndexPath  = self.indexPathForItem(at: self.centerPoint) {
            return centerIndexPath
        }
        return nil
    }
    
}

extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}

extension String {

    func isImage() -> Bool {
        // Add here your image formats.
        let imageFormats = ["jpg", "jpeg", "png", "gif"]
        
        let finalExtension = self.lowercased()

        if let ext = finalExtension.getExtension() {
            return imageFormats.contains(ext)
        }

        return false
    }

    func getExtension() -> String? {
       let ext = (self as NSString).pathExtension

       if ext.isEmpty {
           return nil
       }

       return ext
    }

    func isURL() -> Bool {
       return URL(string: self) != nil
    }

}

extension UIRefreshControl {
    
    func beginRefreshingManually() {
        
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
        }
        beginRefreshing()
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    enum ViewSide {
        case Left, Right, Top, Bottom
    }

    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {

        let border = CALayer()
        border.backgroundColor = color

        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }

        layer.addSublayer(border)
    }
    func addBottomBorderWithColor(color: UIColor, width: CGFloat ,widthView:CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: widthView, height: width)
        self.layer.addSublayer(border)
    }
}
