//
//  ImageDonwloader.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 27.08.2021.
//


import UIKit
import CoreServices


var mapIVURL = [Int: String]()
var imageCache = NSCache<NSString, UIImage>()

func imageFolderPath() -> String {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/"
}

func cacheFolderPath() -> String {
    return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first! + "/"
}

let queue = DispatchQueue.init(label: "decode_queue", autoreleaseFrequency: .workItem)

@discardableResult
func writeCGImage(_ image: CGImage, to destinationURL: URL) -> Bool {
    guard let destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypePNG, 1, nil) else { return false }
    CGImageDestinationAddImage(destination, image, nil)
    return CGImageDestinationFinalize(destination)
}

func downsample(imageAt imageURL: URL, for imageView: UIImageView, to pointSize: CGSize, scale: CGFloat) {
    let setImage = { (image: UIImage) in
        if imageCache.object(forKey: imageURL.relativePath as NSString) == nil {
            imageCache.setObject(image, forKey: imageURL.relativePath as NSString)
        }
        DispatchQueue.main.async {
            guard mapIVURL[imageView.hashValue] == imageURL.relativePath else { return }
            imageView.image = image
        }
    }
    
    if let image = imageCache.object(forKey: imageURL.relativePath as NSString) {
        setImage(image)
        return
    }
    
    queue.async {
        let file = fileName(str: imageURL.relativePath)
        let sourceImagePath = imageFolderPath() + file
        let sourceImageURL = URL(fileURLWithPath: sourceImagePath)
        let destinationImagePath = "\(sourceImagePath)_\(Int(pointSize.width))x\(Int(pointSize.height))_\(Int(scale))"
        let destinationImageURL = URL(fileURLWithPath: destinationImagePath)
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: sourceImagePath) {
            if fileManager.fileExists(atPath: destinationImagePath),
                let data = CGDataProvider(url: destinationImageURL as CFURL),
                let image = CGImage(pngDataProviderSource: data, decode: nil, shouldInterpolate: false, intent: .defaultIntent) {
                setImage(UIImage(cgImage: image))
                return
            }
            
            let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
            guard let imageSource = CGImageSourceCreateWithURL(sourceImageURL as CFURL, imageSourceOptions) else {
                return
            }
            let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
            let downsampleOptions =
                [kCGImageSourceCreateThumbnailFromImageAlways: true,
                 kCGImageSourceShouldCacheImmediately: true,
                 kCGImageSourceCreateThumbnailWithTransform: true,
                 kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
            guard let fullDownsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)  else {
                    return
            }
            
            let fullSize = CGSize(width: fullDownsampledImage.width, height: fullDownsampledImage.height)
            
            let cropRect = CGRect(
                x: round((fullSize.width - pointSize.width * scale) / 2.0),
                y: round((fullSize.height - pointSize.height * scale) / 2.0),
                width: pointSize.width * scale,
                height: pointSize.height * scale
            )
            
            guard let downsampledImage = fullDownsampledImage.cropping(to: cropRect) else {
                return
            }
            
            let isWritten = writeCGImage(downsampledImage, to: destinationImageURL)
            if !isWritten {
                debugPrint("can't save this shit to \(destinationImageURL.absoluteString)")
            }
            
            setImage(UIImage(cgImage: downsampledImage))
        } else {
            OYImageDownloader.shared.download(imageURL) {
                guard let url = $0 else { return }
                do {
                    try? fileManager.removeItem(at: sourceImageURL)
                    try fileManager.copyItem(at: url, to: sourceImageURL)
                } catch {
                    debugPrint([String(describing: error), error.localizedDescription])
                    
                }
                downsample(imageAt: imageURL, for: imageView, to: pointSize, scale: scale)
            }
        }
    }
}

typealias OYImageDownloaderCompletion = (URL?) -> ()

class OYImageDownloaderObserver: NSObject {
    let path: String
    let completion: OYImageDownloaderCompletion
    
    init(path: String, completion: @escaping OYImageDownloaderCompletion) {
        self.path = path
        self.completion = completion
        super.init()
    }
}

class OYImageDownloader {
    enum State {
        case preparing
        case downloading
        case downloaded(URL)
    }
    
    static let shared = OYImageDownloader()
    private let queue = DispatchQueue(label: "OYImageDownloader.Processing")
    private let responseQueue = DispatchQueue(label: "OYImageDownloader.Response")
    var states: [String: State] = .init()
    var observers: Set<OYImageDownloaderObserver> = .init()
    
    func set(state: State?, url: URL) {
        let key = url.relativePath
        states[key] = state
    }
    
    func getState(url: URL) -> State {
        let key = url.relativePath
        if let state = states[key] {
            return state
        } else {
            states[key] = .preparing
            return .preparing
        }
    }
    
    func download(_ imageURL: URL, completion: @escaping (URL?) -> ()) {
        let key = imageURL.relativePath
        queue.async {
            let state = self.getState(url: imageURL)
            switch state {
            case .preparing:
                self.observers.insert(.init(path: key, completion: completion))
                URLSession.shared.downloadTask(with: imageURL) { (url, response, error) in
                    self.notify(url: imageURL, about: url)
                    }.resume()
            case .downloading:
                self.observers.insert(.init(path: key, completion: completion))
            case .downloaded(let url):
                completion(url)
            }
        }
    }
    
    func notify(url: URL, about destination: URL?) {
        let key = url.relativePath
        let cachePath = cacheFolderPath() + UUID().uuidString
        var cacheURL: URL? = nil
        if let url = destination {
            cacheURL = URL(fileURLWithPath: cachePath)
            do {
                try FileManager.default.copyItem(at: url, to: cacheURL!)
            } catch {
                debugPrint("[\(#function)] %@ %@", [String(describing: error), error.localizedDescription])
            }
        }
        queue.async {
            if let result = cacheURL {
                self.set(state: .downloaded(result), url: url)
            } else {
                self.set(state: nil, url: url)
            }
            let result = self.observers.filter{ $0.path == key }
            self.observers.subtract(result)
            self.responseQueue.async {
                result.forEach {
                    $0.completion(cacheURL)
                }
            }
        }
    }
}

enum Test {
    case old
    case new
}

extension UIImageView {
    func setImage(with imageURL: URL) {
        mapIVURL[hashValue] = imageURL.relativePath
        
        let test: Test = .new
        
        switch test {
        case .old:
            break
//            setImageWith(imageURL)
        case .new:
            let scale = UIScreen.main.scale
            downsample(imageAt: imageURL, for: self, to: frame.size, scale: scale)
        }
    }
}


import CommonCrypto

func fileName(str: String) -> String {
    return String(sha256(str: str).suffix(20))
}

func sha256(str: String) -> String {
    if let strData = str.data(using: .utf8) {
        let length = Int(CC_SHA256_DIGEST_LENGTH)
        let digest: [UInt8] = strData.withUnsafeBytes {
            var digest = [UInt8](repeating: 0, count: length)
            CC_SHA256($0.baseAddress, UInt32(strData.count), &digest)
            return digest
        }
        
        let sha256String = digest.reduce("") { $0 + String(format:"%02x", $1) }
        return sha256String
    }
    return ""
}
