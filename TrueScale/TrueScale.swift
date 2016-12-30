//
//  TrueScale.swift
//
//  Created by Reo Hokazono on 2016/12/05.
//  Copyright © 2016年 Reo Hokazono. All rights reserved.
//

import Foundation
import UIKit

public enum TSUnit {
    case mm, cm, inch
}

public struct TSRect {
    public var origin:TSPoint
    public var size:TSSize
    
    public init(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, unit:TSUnit = .mm){
        self.origin = TSPoint(x: x, y: y, unit: unit)
        self.size = TSSize(width: width, height: height, unit: unit)
    }
    
    public init(origin:TSPoint, size:TSSize){
        assert(origin.unit == size.unit, "Cannot use defferent unit between origin & size")
        self.origin = origin
        self.size = size
    }
    
    public var cgrect:CGRect{
        return CGRect(origin: origin.cgpoint, size: size.cgsize)
    }
    
    public var width:CGFloat{
        return size.width
    }
    
    public var height:CGFloat{
        return size.height
    }
    
    public var minX:CGFloat{
        return origin.x
    }
    
    public var midX:CGFloat{
        return (origin.x * 2 + size.width) / 2
    }
    
    public var maxX:CGFloat{
        return origin.x + size.width
    }
    
    public var minY:CGFloat{
        return origin.y
    }
    
    public var midY:CGFloat{
        return (origin.y * 2 + size.height) / 2
    }
    
    public var maxY:CGFloat{
        return origin.y + size.height
    }
    
}

public struct TSSize {
    public var width:CGFloat
    public var height:CGFloat
    public let unit:TSUnit
    public var rlScale = TSScale()
    
    
    public var cgsize:CGSize{
        return CGSize(width: width.toPoint(unit: unit), height: height.toPoint(unit: unit))
    }
    
    public init(width:CGFloat, height:CGFloat, unit:TSUnit = .mm) {
        self.width = width
        self.height = height
        self.unit = unit
    }
    
}

public struct TSPoint {
    public var x:CGFloat
    public var y: CGFloat
    public let unit:TSUnit
    
    
    public var cgpoint:CGPoint{
        return CGPoint(x: x.toPoint(unit: unit), y: y.toPoint(unit: unit))
    }
    
    public init(x:CGFloat, y:CGFloat, unit:TSUnit = .mm){
        self.x = x
        self.y = y
        self.unit = unit
    }
}

public struct TSScale {
    
    var inchRatio:CGFloat = 0
    var iPadMiniPlatforms:[String] = ["iPad2,5","iPad2,6","iPad2,7","iPad4,4","iPad4,5","iPad4,6","iPad4,7","iPad4,8","iPad4,9","iPad5,1","iPad5,2"]
    
    public init() {
        let inchDiagonal = displayInch()
        let bounds = UIScreen.main.bounds
        let pointWidth = bounds.width
        let pointHeight = bounds.height
        let pointDiagonal =  CGFloat(sqrt(powf(Float(pointHeight), 2) + powf(Float(pointWidth), 2)))
        let inchWidth = inch(inchDiagonal: inchDiagonal, pointDiagonal: pointDiagonal, point: pointWidth)
        self.inchRatio = pointWidth / inchWidth
    }
    
    func displayInch()->CGFloat{
        let bounds = UIScreen.main.bounds
        let width = bounds.width < bounds.height ? bounds.width : bounds.height
        let height = bounds.height > bounds.width ? bounds.height : bounds.width
        switch (width, height) {
        case (320,480):
            return 3.5
        case (320,568):
            return 4
        case (375,667):
            return 4.7
        case (414,736):
            return 5.5
        case (768,1024):
            let filterd = iPadMiniPlatforms.filter{ $0 == platform() }
            if filterd.isEmpty{
                return 9.7
            }else{
                return 7.9
            }
        case (1024, 1366):
            return 12.9
        default:
            return 0
        }
    }
    
    public func toPoint(value:CGFloat, unit:TSUnit = .mm)->CGFloat{
        switch unit{
        case .inch:
            return value * inchRatio
        case .mm:
            return toInch(mm: value) * inchRatio
        case .cm:
            return toInch(cm: value) * inchRatio
        }
    }
    
    func inch(inchDiagonal:CGFloat, pointDiagonal:CGFloat, point:CGFloat)->CGFloat{
        return inchDiagonal * point / pointDiagonal
    }
    
    public func toMm(inch:CGFloat)->CGFloat{
        return inch * 25.4
    }
    
    public func toCm(inch:CGFloat)->CGFloat{
        return inch * 2.54
    }
    
    public func toInch(mm:CGFloat)->CGFloat{
        return mm / 25.4
    }
    
    public func toInch(cm:CGFloat)->CGFloat{
        return cm / 2.54
    }
    
    func platform() -> String {
        var size : Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(describing: machine)
    }
    
}

public extension CGFloat{
    public func toPoint(unit:TSUnit)->CGFloat{
        return TSScale().toPoint(value: self, unit: unit)
    }
}
