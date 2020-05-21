//
//  UIImage + Extension.swift
//  iCat
//
//  Created by Stanislav Teslenko on 21.05.2020.
//  Copyright © 2020 Stanislav Teslenko. All rights reserved.
//

import UIKit

extension UIImage {
    
// Create a blur effect
    
    func blurImage(blurAmount: CGFloat) -> UIImage? {
        
        guard let ciImage = CIImage(image: self) else { return nil }
        
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(blurAmount, forKey: kCIInputRadiusKey)
        
        guard let outputImage = blurFilter?.outputImage else {return nil}
        
        return UIImage(ciImage: outputImage)
        
    }
    
    
// Given a required height, returns a (rasterised) copy of the image, aspect-fitted to that height.

    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage
    {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
}
