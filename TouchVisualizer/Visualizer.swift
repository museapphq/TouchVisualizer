//
//  TouchVisualizer.swift
//  TouchVisualizer
//

import UIKit

final public class Visualizer:NSObject {
    
    // MARK: - Public Variables
    static public let sharedInstance = Visualizer()
    public var numDirectActiveTouches: Int = 0

    fileprivate var enabled = false
    fileprivate var config: Configuration!
    fileprivate var touchViews = [TouchView]()
    fileprivate var previousLog = ""
    
    // MARK: - Object life cycle
    private override init() {
      super.init()
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(Visualizer.orientationDidChangeNotification(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(Visualizer.applicationDidBecomeActiveNotification(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        UIDevice
            .current
            .beginGeneratingDeviceOrientationNotifications()
        
        warnIfSimulator()
    }
    
    deinit {
        NotificationCenter
            .default
            .removeObserver(self)
    }
    
    // MARK: - Helper Functions
    @objc internal func applicationDidBecomeActiveNotification(_ notification: Notification) {
        UIApplication.shared.keyWindow?.swizzle()
    }
    
    @objc internal func orientationDidChangeNotification(_ notification: Notification) {
        let instance = Visualizer.sharedInstance
        for touch in instance.touchViews {
            touch.removeFromSuperview()
        }
    }
    
    public func removeAllTouchViews() {
        for view in self.touchViews {
            view.removeFromSuperview()
        }
    }
}

extension Visualizer {
    public class func isEnabled() -> Bool {
        return sharedInstance.enabled
    }
    
    // MARK: - Start and Stop functions
    
    public class func start(_ config: Configuration = Configuration()) {

        let instance = sharedInstance
        instance.enabled = true
        instance.config = config
        
        if let window = UIApplication.shared.keyWindow {
            for subview in window.subviews {
                if let subview = subview as? TouchView {
                    subview.removeFromSuperview()
                }
            }
        }
    }
    
    public class func stop() {
        let instance = sharedInstance
        instance.enabled = false
        
        for touch in instance.touchViews {
            touch.removeFromSuperview()
        }
    }
    
    public class func getTouches() -> [UITouch] {
        let instance = sharedInstance
        var touches: [UITouch] = []
        for view in instance.touchViews {
            guard let touch = view.touch else { continue }
            touches.append(touch)
        }
        return touches
    }
    
    // MARK: - Dequeue and locating TouchViews and handling events
    private func dequeueTouchView() -> TouchView {
        var touchView: TouchView?
        for view in touchViews {
            if view.superview == nil {
                touchView = view
                break
            }
        }
        
        if touchView == nil {
            touchView = TouchView()
            touchViews.append(touchView!)
        }
        
        return touchView!
    }
    
    private func findTouchView(_ touch: UITouch) -> TouchView? {
        for view in touchViews {
            if touch == view.touch {
                return view
            }
        }
        
        return nil
    }
    
    public func handleEvent(_ event: UIEvent) {
        guard event.type == .touches, let allTouches = event.allTouches else {
            return
        }

        numDirectActiveTouches = allTouches
            .filter { $0.type == .direct && $0.phase != .ended && $0.phase != .cancelled }
            .count
        
        guard
            Visualizer.sharedInstance.enabled,
            let topWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        else {
            return
        }

        for touch in allTouches {
            let phase = touch.phase
            switch phase {
            case .began:
                let view = dequeueTouchView()
                view.config = Visualizer.sharedInstance.config
                view.touch = touch
                view.beginTouch()
                view.center = touch.location(in: topWindow)
                topWindow.addSubview(view)
            case .moved:
                if let view = findTouchView(touch) {
                    view.center = touch.location(in: topWindow)
                }
            case .ended, .cancelled:
                if let view = findTouchView(touch) {
                    view.removeFromSuperview()
                }
            default:
                continue

            }
        }
    }
}

extension Visualizer {
    public func warnIfSimulator() {
        #if targetEnvironment(simulator)
            print("[TouchVisualizer] Warning: TouchRadius doesn't work on the simulator because it is not possible to read touch radius on it.", terminator: "")
        #endif
    }
}
