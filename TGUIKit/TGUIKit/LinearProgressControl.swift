//
//  LinearProgressControl.swift
//  TGUIKit
//
//  Created by keepcoder on 28/10/2016.
//  Copyright © 2016 Telegram. All rights reserved.
//

import Cocoa

public class LinearProgressControl: Control {
    
    private var progressView:View!
    private var progress:CGFloat = 0
    public var onUserChanged:((Float)->Void)?
    
    public override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        if let onUserChanged = onUserChanged {
            let location = convert(event.locationInWindow, from: nil)
            let progress = Float(location.x / frame.width)
            onUserChanged(progress)
        }
    }
    
    public var interactiveValue:Float {
        if let window = window {
            let location = convert(window.mouseLocationOutsideOfEventStream, from: nil)
            return Float(location.x / frame.width)
        }
        return 0
    }
    
    open override func updateTrackingAreas() {
        super.updateTrackingAreas();
        
        if let trackingArea = trackingArea {
            self.removeTrackingArea(trackingArea)
        }
        
        let options:NSTrackingAreaOptions = [NSTrackingAreaOptions.cursorUpdate, NSTrackingAreaOptions.mouseEnteredAndExited, NSTrackingAreaOptions.mouseMoved, NSTrackingAreaOptions.enabledDuringMouseDrag, NSTrackingAreaOptions.activeInKeyWindow,NSTrackingAreaOptions.inVisibleRect]
        self.trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        
        self.addTrackingArea(self.trackingArea!)
    }
    
    public override var style: ControlStyle {
        didSet {
            self.progressView.layer?.backgroundColor = style.foregroundColor.cgColor
        }
    }
    
    public func set(progress:CGFloat, animated:Bool = false) {
        self.progress = progress
        let size = NSMakeSize(floorToScreenPixels(frame.width * progress), frame.height)
        progressView.change(size: size, animated: animated)
    }
    

    override init() {
        super.init()
        initialize()
    }
    
    public override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)
        progressView.setFrameSize(progressView.frame.width,newSize.height)
    }
    
    private func initialize() {
        progressView = View(frame:NSMakeRect(0, 0, 0, frame.height))
        progressView.layer?.backgroundColor = style.foregroundColor.cgColor
        addSubview(progressView)
    }
    
    required public init(frame frameRect: NSRect) {
        super.init(frame:frameRect)
        initialize()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}