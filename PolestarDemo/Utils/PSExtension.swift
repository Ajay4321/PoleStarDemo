//
//  PSExtension.swift
//  PolestarDemo
//
//  Created by Ajay Awasthi on 05/03/22.
//

import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

// Download image from url and stored in imageCache
extension UIImageView {
    func load(urlString : String) {
        
        if let image = imageCache.object(forKey: urlString as NSString) as? UIImage{
            self.image = image
            return
        }
        guard let url = URL(string: urlString)else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self?.image = image
                    }
                }
            }
        }
    }
}

// Toast
func showToast(controller: UIViewController, message: String, duration: Double){
    let alert = UIAlertController(title: "PoleStar Dialog", message: message, preferredStyle: .alert)
    alert.view.backgroundColor = UIColor.black
    alert.view.alpha = 0.6
    alert.view.layer.cornerRadius = 15
    controller.present(alert, animated: true)
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration){
        alert.dismiss(animated: true)
    }
}

// Validating Search text
func isValidString(string: String) -> Bool{
    let cs = CharacterSet(charactersIn: PSUrlConstants.BookSearchAcceptableCharactes).inverted
            let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
    let isValid:Bool = filtered.count > 0 ? true : false
    return isValid    
}
