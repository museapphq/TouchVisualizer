//
//  Configuration.swift
//  TouchVisualizer
//

import UIKit

public struct Configuration {
    /**
     Color of touch points
     */
    public var touchColor: UIColor? = UIColor(
        red: 18/255.0,
        green: 77/255.0,
        blue: 170/255.0, alpha: 0.4)

    /**
     Color of stylus points
     */
    public var stylusInkColor: UIColor? = UIColor(
        red: 18/255.0,
        green: 117/255.0,
        blue: 18/255.0, alpha: 0.4)

    public var stylusLowAngleColor: UIColor? = UIColor(
        red: 170/255.0,
        green: 89/255.0,
        blue: 18/255.0, alpha: 0.4)

    // Image of touch points
    public var image: UIImage? = {
        let rect = CGRect(x: 0.0, y: 0.0, width: 60.0, height: 60.0)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let contextRef = UIGraphicsGetCurrentContext()
        contextRef?.setFillColor(UIColor.white.cgColor)
        contextRef?.fillEllipse(in: rect)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image?.withRenderingMode(.alwaysTemplate)
    }()



    /**
     Default touch point size. If `showsTouchRadius` is enabled, this value is ignored
     */
    public var defaultSize = CGSize(width: 60.0, height: 60.0)

    /**
     Default touch point size. If `showsTouchRadius` is enabled, this value is ignored
     */
    public var stylusSize = CGSize(width: 20.0, height: 20.0)

    public init(){}
}
