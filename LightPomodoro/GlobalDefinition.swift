//
//  GlobalDefinition.swift
//  LightPomodoro
//
//  Created by 王嘉宁 on 2020/12/4.
//  Copyright © 2020 Johnny. All rights reserved.
//

import Foundation
import UIKit

// MARK: Foundation

func SAFE_OBJECT_FROM<T>(arr: Array<T>, index: Int) -> T? {
    if index < arr.count {
        return arr[index]
    } else {
        return nil
    }
}

// MARK: UI

enum FontType {
    case title
    case detail
}

func FONT(type: FontType, size: CGFloat) -> UIFont? {
    return UIFont(name: "PingFangSC-Regular", size: size)
}

func COLOR(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(displayP3Red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

// MARK: const

public typealias VoidBlock = (() -> (Void))
public typealias TimeIntervalBlock = ((TimeInterval) -> ())

// MARK: protocol

public protocol CustomNibViewProtocol where Self: UIView {
}

extension CustomNibViewProtocol {
    public static func getView(defaultView: Self) -> Self {
        let nibName = String(describing: Self.self)
        let nibArr = Bundle(for: Self.self).loadNibNamed(nibName, owner: nil, options: nil) ?? []
        let view = nibArr.compactMap { $0 }.first as? Self ?? defaultView
        return view
    }
}

// MARK: constraint

enum ConstraintAttribute {
    case notAnAttribute
    
    case left
    case right
    case top
    case bottom
    case centerX
    case centerY
    case width
    case height
}

extension UIView {
    var lpj: LPJConstarint {
        return LPJConstarint(view: self)
    }
}

public class LPJConstarint {
    
    var firstConstraint: ConstraintAttribute?
    var secondConstraint: ConstraintAttribute?
    var secondItem: UIView?
    var multiplier: CGFloat = 1
    var offset: CGFloat = 0
    var isSetWidth: Bool = false
    var isSetHeight: Bool = false
    
    var left: Self {
        if let _ = secondItem {
            secondConstraint = .left
        } else {
            firstConstraint = .left
        }
        return self
    }
    
    var right: Self {
        if let _ = secondItem {
            secondConstraint = .right
        } else {
            firstConstraint = .right
        }
        return self
    }
    
    var top: Self {
        if let _ = secondItem {
            secondConstraint = .top
        } else {
            firstConstraint = .top
        }
        return self
    }
    
    var bottom: Self {
        if let _ = secondItem {
            secondConstraint = .bottom
        } else {
            firstConstraint = .bottom
        }
        return self
    }
    
    var centerX: Self {
        if let _ = secondItem {
            secondConstraint = .centerX
        } else {
            firstConstraint = .centerX
        }
        return self
    }
    
    var centerY: Self {
        if let _ = secondItem {
            secondConstraint = .centerY
        } else {
            firstConstraint = .centerY
        }
        return self
    }
    
    var widthConstant: Self {
        isSetWidth = true
        return self
    }
    
    var heightConstant: Self {
        isSetHeight = true
        return self
    }
    
    let view: UIView
    
    init(view: UIView) {
        self.view = view
    }
    
    func to(item: UIView?) -> Self {
        secondItem = item
        return self
    }
    
    func multiplyBy(constant: CGFloat) -> Self {
        multiplier = constant
        return self
    }
    
    // view to view
    func offset(constant: CGFloat, safeArea: Bool = true) {
        if
            let firstTmp = firstConstraint,
            let secondTmp = secondConstraint,
            multiplier > 0 {
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let firstLayoutItem: Any = safeArea ? self.view.safeAreaLayoutGuide : self.view
            let secondLayoutItem: Any? = safeArea ? secondItem?.safeAreaLayoutGuide : secondItem
            
            let constraint = NSLayoutConstraint(item: firstLayoutItem,
                                                attribute: getAttribute(attr: firstTmp),
                                                relatedBy: .equal,
                                                toItem: secondLayoutItem,
                                                attribute: getAttribute(attr: secondTmp),
                                                multiplier: multiplier,
                                                constant: constant)
            constraint.isActive = true
        }
        
    }
    
    // width or height
    func equalTo(constant: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        var attr: ConstraintAttribute = .notAnAttribute
        if isSetWidth {
            attr = .width
        } else if isSetHeight {
            attr = .height
        }
        let constraint = NSLayoutConstraint(item: self.view,
                                            attribute: getAttribute(attr: attr),
                                            relatedBy: .equal,
                                            toItem: secondItem,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: constant)
        constraint.isActive = true
    }
    
    func getAttribute(attr: ConstraintAttribute) -> NSLayoutConstraint.Attribute {
        switch attr {
        case .left:
            return .left
        case .right:
            return .right
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .centerX:
            return .centerX
        case .centerY:
            return .centerY
        case .width:
            return .width
        case .height:
            return .height
        case .notAnAttribute:
            return .notAnAttribute
        }
    }
    
    func removeAllConstraint() {
        view.removeConstraints(view.constraints)
    }
}
