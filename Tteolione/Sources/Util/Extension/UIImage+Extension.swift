//
//  UIImage+Extension.swift
//  Tteolione
//
//  Created by 전준영 on 2/5/25.
//

import UIKit
import RxSwift

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage? {
        let newSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage else {
            return nil
        }
        
        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        context.rotate(by: radians)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let origin = CGPoint(x: -size.width / 2, y: -size.height / 2)
        context.draw(cgImage, in: CGRect(origin: origin, size: size))
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rotatedImage
    }
    
    static func load(from url: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
    
    static func loadImage(from url: URL) -> Observable<UIImage?> {
        return Observable.create { observer in
            Task {
                let image = await load(from: url)
                observer.onNext(image)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    static func loadSync(from url: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
}
