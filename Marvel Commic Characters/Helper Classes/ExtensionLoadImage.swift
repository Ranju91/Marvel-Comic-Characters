//
//  LoadImage.swift
//  Marvel Commic Characters
//
//  Created by Ranjana on 04/09/22.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageFromCache(withUrl urlString : String) {
        guard let url = URL(string: urlString) else {return}
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .medium)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                return
            }
            DispatchQueue.main.async {
                guard let imageData = data else {return}
                if let image = UIImage(data: imageData) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }
        }).resume()
    }
}
