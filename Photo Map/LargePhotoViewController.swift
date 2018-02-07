//
//  LargePhotoViewController.swift
//  Photo Map
//
//  Created by Nathan Hays on 2/3/18.
//  Copyright © 2018 Nathan Hays. All rights reserved.
//

import UIKit
import Photos

class LargePhotoViewController: UIViewController {
    
    var photoDetail: PHAsset?
    
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var labelCoord: UILabel!
    @IBOutlet weak var labelPhotoAddress: UILabel!
    @IBOutlet weak var imageStaticMap: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let image  = Helper.getUIImage(asset: photoDetail!)
        imagePhoto.image = image
        
        let latitude = self.photoDetail!.location!.coordinate.latitude
        let longitude = self.photoDetail!.location!.coordinate.longitude
        
        labelCoord.text = "<" + String(latitude) + " , " + String(longitude) + ">"
        
        Helper.getAddressFromLatLon(loc: photoDetail?.location)  { (result) -> () in
            self.labelPhotoAddress.text = result
        }
        
        Helper.getStaticMap(location: (photoDetail!.location!.coordinate)) { (result) in
            self.imageStaticMap.image = result
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imagePhoto?.isHidden = true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
