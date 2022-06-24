//
//  PixelData.swift
//  planetgentest
//
//  Created by Matt Condon on 4/27/16.
//  Copyright © 2016 mattc. All rights reserved.
//

import UIKit
import CoreGraphics

// MARK: Image Generation

//
//  drawing images from pixel data
//      http://blog.human-friendly.com/drawing-images-from-pixel-data-in-swift
//


struct PixelData {
    var a:UInt8 = 255
    var r:UInt8
    var g:UInt8
    var b:UInt8
}

struct PixelDrawer {
    static let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    static let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)

    static func imageFromARGB32Bitmap(pixels:[PixelData], width:Int, height:Int) -> UIImage {
        let bitsPerComponent:Int = 8
        let bitsPerPixel:Int = 32

        assert(pixels.count == Int(width * height))

        var data = pixels // Copy to mutable []

        guard let providerRef = CGDataProvider(data: Data(bytes: &data, count: data.count * MemoryLayout.size(ofValue: PixelData.self)) as CFData) else { return UIImage() }

        let cgim = CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: width * Int(MemoryLayout.size(ofValue: PixelData.self)),
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent
        )
        return UIImage(cgImage: cgim!)
    }

}

extension UIColor {
    var pixelData : PixelData {
        get {
            var red : CGFloat = 0
            var green : CGFloat = 0
            var blue : CGFloat = 0
            var alpha : CGFloat = 0

            getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            return PixelData(
                a: UInt8(alpha * 255),
                r: UInt8(red * 255),
                g: UInt8(green * 255),
                b: UInt8(blue * 255)
            )
        }
    }
}
