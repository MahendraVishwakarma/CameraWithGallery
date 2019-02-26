//
//  PHAssestLib.swift
//  CameraGallery
//
//  Created by Mahendra Vishwakarma on 26/02/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import Foundation
import Photos
import UIKit

class PHAssestLib{
    
   static var photos = [UIImage]()
    class func fetchImage(completion: @escaping ((Array<UIImage>) -> ())) {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        fetchOptions.fetchLimit = 10
        
        
        let images = PHAsset.fetchAssets(with: .image, options: fetchOptions) // PHAsset.fetchAssets(with: fetchOptions)
        
        let options = PHImageRequestOptions()
        options.version = .original
        
        
        for countIndex in 0..<images.count {
            let assest = images.object(at: countIndex)
            
            PHImageManager.default().requestImageData(for: assest, options: nil) {
                data, uti, orientation, info in
                
                guard let data =  data else{
                    return
                }
                
                guard let image = UIImage(data: data) else{
                    return
                }
                
                self.photos.append(image)
                if(self.photos.count == images.count){
                    completion(self.photos)
                }
                
            }
            
        }
    }
}


