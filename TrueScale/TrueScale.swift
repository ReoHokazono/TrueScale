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
    var origin:TSPoint
    var size:TSSize
    
    init(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, unit:TSUnit = .mm){
        self.origin = TSPoint(x: x, y: y, unit: unit)
        self.size = TSSize(width: width, height: height, unit: unit)
    }
    
    init(origin:TSPoint, size:TSSize){
        assert(origin.unit == size.unit, "Cannot use defferent unit between origin & size")
        self.origin = origin
        self.size = size
    }
    
    var cgrect:CGRect{
        return CGRect(origin: origin.cgpoint, size: size.cgsize)
    }
    
    var width:CGFloat{
        return size.width
    }
    
    var height:CGFloat{
        return size.height
    }
    
    var minX:CGFloat{
        return origin.x
    }
    
    var midX:CGFloat{
        return (origin.x * 2 + size.width) / 2
    }
    
    var maxX:CGFloat{
        return origin.x + size.width
    }
    
    var minY:CGFloat{
        return origin.y
    }
    
    var midY:CGFloat{
        return (origin.y * 2 + size.height) / 2
    }
    
    var maxY:CGFloat{
        return origin.y + size.height
    }
    
}

public struct TSSize {
    var width:CGFloat
    var height:CGFloat
    var unit:TSUnit
    var rlScale = TSScale()
    
    
    var cgsize:CGSize{
        return CGSize(width: width.toPoint(unit: unit), height: height.toPoint(unit: unit))
    }
    
    init(width:CGFloat, height:CGFloat, unit:TSUnit = .mm) {
        self.width = width
        self.height = height
        self.unit = unit
    }
    
}

public struct TSPoint {
    var x:CGFloat
    var y: CGFloat
    var unit:TSUnit
    
    
    var cgpoint:CGPoint{
        return CGPoint(x: x.toPoint(unit: unit), y: y.toPoint(unit: unit))
    }
    
    init(x:CGFloat, y:CGFloat, unit:TSUnit = .mm){
        self.x = x
        self.y = y
        self.unit = unit
    }
}

public struct TSScale {
    
    private var inchRatio:CGFloat = 0
    private var iPadMiniPlatforms:[String] = ["iPad2,5","iPad2,6","iPad2,7","iPad4,4","iPad4,5","iPad4,6","iPad4,7","iPad4,8","iPad4,9","iPad5,1","iPad5,2"]
    
    init() {
        let inchDiagonal = displayInch()
        let bounds = UIScreen.main.bounds
        let pointWidth = bounds.width
        let pointHeight = bounds.height
        let pointDiagonal =  CGFloat(sqrt(powf(Float(pointHeight), 2) + powf(Float(pointWidth), 2)))
        let inchWidth = inch(inchDiagonal: inchDiagonal, pointDiagonal: pointDiagonal, point: pointWidth)
        self.inchRatio = pointWidth / inchWidth
    }
    
    private func displayInch()->CGFloat{
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
    
    func toPoint(value:CGFloat, unit:TSUnit = .mm)->CGFloat{
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
    
    func toMm(inch:CGFloat)->CGFloat{
        return inch * 25.4
    }
    
    func toCm(inch:CGFloat)->CGFloat{
        return inch * 2.54
    }
    
    func toInch(mm:CGFloat)->CGFloat{
        return mm / 25.4
    }
    
    func toInch(cm:CGFloat)->CGFloat{
        return cm / 2.54
    }
    
    private func platform() -> String {
        var size : Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(describing: machine)
    }
    
}

extension CGFloat{
    public func toPoint(unit:TSUnit)->CGFloat{
        return TSScale().toPoint(value: self, unit: unit)
    }
}
