//
//  ExtensionUIImage.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 26/08/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Extension of UIImage For Converting UIImage TO Data
extension UIImage {
    
    /// This Method is Used For Converting UIImage TO Data?
    ///
    /// - Parameter compressionQuality: A CGFloat value that indicates how much compressionQuality you want , its optional so you can pass nil.
    /// - Returns: This Method returns Data? , it means this method return nil value also , while using this method please use if let. If you are not using if let and if this method returns nil and when you are trying to unwrapped this value("Data!") then application will crash.
    func imgData(compressionQuality:CGFloat?) -> Data? {
        return UIImageJPEGRepresentation(self, compressionQuality ?? 0.0)
    }
    
    func resizeImage(newSize:CGSize) -> UIImage? {
        
        var newImage:UIImage?
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContext(newSize)
        
        if let _ = UIGraphicsGetCurrentContext() {
            
            draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
            
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                
                UIGraphicsEndImageContext()
                newImage = image
            }
        }
        
        return newImage
    }
    
    func blurImage(radius:CGFloat) -> UIImage? {
        
        guard let cgImage = self.cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        let affineClampFilter = CIFilter(name: "CIAffineClamp")
        affineClampFilter?.setDefaults()
        affineClampFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let clampedCIImage = affineClampFilter?.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
        
        let exposureAdjustFilter = CIFilter(name: "CIExposureAdjust")
        
        exposureAdjustFilter?.setValue(-1, forKey: kCIInputEVKey)
        exposureAdjustFilter?.setValue(clampedCIImage, forKey: kCIInputImageKey)
        
        guard let exposuredCIImage = exposureAdjustFilter?.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
        
        let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur")
        
        gaussianBlurFilter?.setValue("\(radius)", forKey: kCIInputRadiusKey)
        gaussianBlurFilter?.setValue(exposuredCIImage, forKey: kCIInputImageKey)
        
        guard let gaussianCIImage = gaussianBlurFilter?.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
        
        let context = CIContext(options: nil)
        
        guard let gaussianCGImage =
            
            context.createCGImage(gaussianCIImage, from: ciImage.extent)
            
            else { return nil }
        
        return UIImage(cgImage: gaussianCGImage)
    }
    
}

/*
 
 Reference :-  https://github.com/bahlo/SwiftGif
 
*/

extension UIImage {
    
    public class func gif(data: Data) -> UIImage? {
        
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gif(url: URL) -> UIImage? {
        
        guard let imageData = try? Data(contentsOf: url) else { return nil }
        return gif(data: imageData)
    }
    
    public class func gif(name: String) -> UIImage? {
        
        guard let bundleURL = CMainBundle.url(forResource: name, withExtension: "gif") else { return nil }
        
        return gif(url: bundleURL)
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        
        var delay = 0.02
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as? Double ?? 0
        
        if delay < 0.02 {
            delay = 0.02
        }
        
        return delay
    }
    
    internal class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        
        var a = a
        var b = b
        
        if b == nil || a == nil {
            
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a! < b! {
            
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        
        while true {
            
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    internal class func gcdForArray(_ array: Array<Int>) -> Int {
        
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0))
        }
        
        let duration: Int = {
            
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        
        for i in 0..<count {
            
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
    
    static func imageFromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        // create a 1 by 1 pixel context
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
        
    }
}
