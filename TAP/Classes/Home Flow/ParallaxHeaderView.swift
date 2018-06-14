//
//  ParallaxHeaderView.swift
//  demoStrechyHeader
//
//  Created by Mac-00016 on 20/03/18.
//  Copyright © 2018 Mac-00016. All rights reserved.
//

import UIKit
import QuartzCore

let kParallaxDeltaFactor: CGFloat = 0.5
let kMaxTitleAlphaOffset: CGFloat = 100.0
let kLabelPaddingDist: CGFloat = 8.0

class ParallaxHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var imageScrollView : UIScrollView!
    var subView : UIView!
    var kDefaultHeaderFrame : CGRect!

    class func parallaxHeaderView(withSubView subView: UIView!) -> ParallaxHeaderView {
        let vwHeader = ParallaxHeaderView(frame: CGRect(x: 0, y: 0, width: CScreenWidth, height: subView?.frame.size.height ?? 0.0)) //subView?.frame.size.width ?? 0.0
        vwHeader.initialSetUp(subView: subView)
        return vwHeader
    }

    
    func initialSetUp(subView: UIView)
    {
        let scrollView = UIScrollView(frame: self.bounds)
        self.imageScrollView = scrollView
        self.subView = subView
        
        subView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleHeight, .flexibleWidth]
        kDefaultHeaderFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.imageScrollView.addSubview(subView)
        self.addSubview(self.imageScrollView)
        
    }
    
    func layoutHeadeForScrollViewOffset(offset: CGPoint)
    {
        var frame = self.imageScrollView.frame
        
        if offset.y > 0
        {
            frame.origin.y = max(offset.y * kParallaxDeltaFactor, 0)
            self.imageScrollView.frame = frame
            self.clipsToBounds = true
        }
        else
        {
            
            var delta: CGFloat = 0.0
            var rect = kDefaultHeaderFrame!
            delta = CGFloat(fabsf(Float(min(0.0, offset.y))))
            rect.origin.y -= delta
            rect.size.height += delta
            self.imageScrollView.frame = rect
            self.clipsToBounds = false
            
        }
    }

}
