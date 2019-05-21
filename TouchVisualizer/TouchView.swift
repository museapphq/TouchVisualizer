//
//  TouchView.swift
//  TouchVisualizer
//

import UIKit

final public class TouchView: UIImageView {
    
    // MARK: - Public Variables
    internal weak var touch: UITouch?
    private var _config: Configuration
    private var previousRatio: CGFloat = 1.0
    
    public var config: Configuration {
        get { return _config }
        set (value) {
            _config = value
            tintColor = self.config.touchColor

        }
    }

    // MARK: - Object life cycle
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        _config = Configuration()
        super.init(frame: frame)
        
        self.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: _config.defaultSize)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Begin and end touching functions
    internal func beginTouch() {
        guard let touch = touch else { return }

        var size = _config.defaultSize
        if #available(iOS 9.1, *) {
            if touch.type == .direct {
                tintColor = _config.touchColor
            } else if touch.type == .pencil {
                size = _config.stylusSize
                if touch.altitudeAngle < 0.65 {
                    tintColor = _config.stylusLowAngleColor
                } else {
                    tintColor = _config.stylusInkColor
                }
            }
        }
        
        alpha = 1.0
        layer.transform = CATransform3DIdentity
        previousRatio = 1.0
        frame = CGRect(origin: frame.origin, size: size)
    }
}
