//
//  Common.swift
//  EhPanda
//
//  Created by 荒木辰造 on R 2/11/22.
//

import SwiftUI
import AlamofireImage

class Common {
    
}

public func ePrint(_ error: Error) {
    print(error.localizedDescription)
}

public func ePrint(_ string: String) {
    print(string)
}

public func ePrint(_ string: String?) {
    print(string ?? "エラーの内容が解析できませんでした")
}

public func executeMainAsyncally(_ closure: @escaping (()->())) {
    if Thread.isMainThread {
        closure()
    } else {
        DispatchQueue.main.async {
            closure()
        }
    }
}

public func executeAsyncally(_ closure: @escaping (()->())) {
    DispatchQueue.global().async {
        closure()
    }
}

enum ImageScaleType {
    case cover
    case preview
}

final class ImageContainer: ObservableObject {
    @Published var image: SwiftUI.Image
    
    init(from resource: String, type: ImageScaleType, _ targetHeight: CGFloat) {
        if let uiImage = UIImage(named: "Placeholder") {
            image = ImageScaler.getScaledImage(uiImage: uiImage, targetHeight: targetHeight, type: type)
        } else {
            image = Image("Placeholder")
        }
        
        guard let url = URL(string: resource) else { return }
        
        let downloader = ImageDownloader()
        downloader.download(URLRequest(url: url), completion: { [weak self] (resp) in
            if case .success(let image) = resp.result {
                DispatchQueue.main.async {
                    self?.image = ImageScaler.getScaledImage(uiImage: image, targetHeight: targetHeight, type: type)
                }
            }
        })
    }
}

class ImageScaler {
    static func getScaledImage(uiImage: UIImage, targetHeight: CGFloat, type: ImageScaleType) -> SwiftUI.Image {
        let width = uiImage.size.width
        let height = uiImage.size.height
        let targetRatio_Cover: CGFloat = 14 / 22
        let targetRatio_Preview: CGFloat = 32 / 45
        
        var targetSize: CGSize {
            CGSize(width: targetHeight * targetRatio, height: targetHeight)
        }
        var targetRatio: CGFloat {
            switch type {
            case .cover:
                return targetRatio_Cover
            case .preview:
                return targetRatio_Preview
            }
        }
        
        if type == .preview {
            return Image(uiImage: uiImage.af.imageAspectScaled(toFill: targetSize))
        }
        
        if (width / height) - targetRatio < 0.2 {
            return Image(uiImage: uiImage.af.imageAspectScaled(toFill: targetSize))
        } else {
            return Image(uiImage: uiImage.af.imageAspectScaled(toFit: targetSize))
        }
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
