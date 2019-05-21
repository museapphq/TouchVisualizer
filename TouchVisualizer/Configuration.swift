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
        red: 52/255.0,
        green: 152/255.0,
        blue: 21/255.0, alpha: 0.4)

    /**
     Color of stylus points
     */
    public var stylusInkColor: UIColor? = UIColor(
        red: 46/255.0,
        green: 117/255.0,
        blue: 18/255.0, alpha: 0.4)

    public var stylusLowAngleColor: UIColor? = UIColor(
        red: 170/255.0,
        green: 89/255.0,
        blue: 18/255.0, alpha: 0.4)

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
