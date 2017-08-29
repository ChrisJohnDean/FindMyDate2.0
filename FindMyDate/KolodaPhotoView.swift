//
//  KolodaPhotoView.swift
//  FindMyDate
//
//  Created by Chris Dean on 2017-08-16.
//  Copyright © 2017 Chris Dean. All rights reserved.
//

import UIKit

extension UIImageView {
    public func imageFromURL(_ urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
//            if error != nil {
//                print(error ?? <#default value#>)
//                return
//            }
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data)
                self.image = image 
            })
            
        }).resume()
    }
}



//extension UIImageView {
//    public func imageFromUrl(_ urlString: String) {
//        if let url = URL(string: urlString) {
//            let request = URLRequest(url: url)
//            URLSession.dataTask(<#T##URLSession#>)
//            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {[unowned self] response, data, error in
//                if let data = data {
//                    self.image = UIImage(data: data)
//                }
//            })
//        }
//    }
//}

class KolodaPhotoView: UIView {
    
//    @IBOutlet var photoImageView: UIImageView?
//    @IBOutlet var photoTitleLabel: UILabel?
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var photoTitle: UILabel!
    
    
}
