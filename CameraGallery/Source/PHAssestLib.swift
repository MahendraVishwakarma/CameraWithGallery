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
    class func fetchImage(completion: @escaping ((PHFetchResult<PHAsset>) -> ())) {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        //fetchOptions.fetchLimit = 30
        fetchOptions.includeAssetSourceTypes = [.typeCloudShared,.typeiTunesSynced,.typeUserLibrary]
        
        let images = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        completion(images)
        
        
    }
    
    class func setupPhotos() {
        let fetchOptions = PHFetchOptions()
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: fetchOptions)
        let topLevelUserCollections = PHCollectionList.fetchTopLevelUserCollections(with: fetchOptions)
        let allAlbums:NSArray = [topLevelUserCollections, smartAlbums]
        
        
        allAlbums.enumerateObjects {(assetCollection, index, stop) in
            
            if #available(iOS 9.0, *) {
                fetchOptions.fetchLimit = 1
            }
            
            let assets = PHAsset.fetchAssets(in: assetCollection as! PHAssetCollection, options: fetchOptions)
            if let _ = assets.firstObject {
                
               // let assetObject = MYSpecialAssetContainerStruct(asset: assets)
               // self.myDataArray.append(assetObject)
            }
        }
//        self.myDataArray.sortInPlace {(a, b) in
//            return a.asset.localizedTitle < b.asset.localizedTitle
//        }
       // tableView.reloadData()
    }
}


