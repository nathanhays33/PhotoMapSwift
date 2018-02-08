//
//  Helper.swift
//  Photo Map
//
//  Created by Nathan Hays on 2/5/18.
//  Copyright © 2018 Nathan Hays. All rights reserved.
//

import UIKit
import Photos

class Helper {
    
    static var photosData : PHFetchResult<PHAsset>?
    static var photoCities : [String : Set<PHAsset>]?
    
    static func getUIImage(asset: PHAsset) -> UIImage? {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
    
    static func getAddressFromLatLon(loc :CLLocation?,
                                     completion: @escaping (_ result: String)->()) {
        let ceo: CLGeocoder = CLGeocoder()
        
        if loc === nil {
            completion("Address was not found")
        }
        
        ceo.reverseGeocodeLocation(loc!, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    completion("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    completion(addressString)
                }
        })
    }
    
    static func getCityFromLatLon(loc :CLLocation?,
                                  completion: @escaping (_ result: String)->()) {
        let ceo: CLGeocoder = CLGeocoder()
        
        if loc === nil {
            completion("Address was not found")
        }
        
        ceo.reverseGeocodeLocation(loc!, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    completion("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    if pm.locality != nil {
                        completion(pm.subLocality!)
                    } else {
                        completion("Lost")
                    }
                }
        })
    }
    
    
    
    static func getCities() {
        if photoCities == nil {
            photoCities  = [String : Set<PHAsset>]()
        } else {
            
        }
        
        loadPhotos { (results) in
            results.enumerateObjects{(object: AnyObject!,
                index: Int,
                stop: UnsafeMutablePointer<ObjCBool>) in
                if object is PHAsset {
                    let photo = object as! PHAsset
                    if let location = photo.location {
                        getCityFromLatLon(loc: location, completion: { (city) in
                            var set = photoCities![city]
                            set?.insert(photo)
                        })
                    }
                }
            }
            
        }
    }
    
    
    static func loadPhotos(completion: @escaping (_ result: PHFetchResult<PHAsset>)->()){
        
        if photosData != nil {
            completion(photosData!)
        }
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                let fetchOptions = PHFetchOptions()
                photosData = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            case .denied, .restricted:
                print("denied")
            case .notDetermined:
                print("not determined")
            }
            completion(photosData!)
        }
    }
    
    func getPhotos() -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        return PHAsset.fetchAssets(with: .image, options: fetchOptions)
    }
    
    static func getStaticMap(location : CLLocationCoordinate2D, completion: @escaping (_ result: UIImage?)->() ){
        let urlString: String = "http://maps.google.com/maps/api/staticmap?markers=color:blue|\(location.latitude),\(location.longitude)&zoom=13&size=200x200&sensor=true"
        
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                completion(UIImage(data: data!))
            }
        }
    }
    
    
    func photoLibraryAvailabilityCheck()
    {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
        {
        }
        else
        {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    func requestAuthorizationHandler(status: PHAuthorizationStatus)
    {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
        {
        }
        else
        {
            // encourage to allow access
        }
    }
}
