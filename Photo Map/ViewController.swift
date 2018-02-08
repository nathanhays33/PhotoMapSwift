//
//  ViewController.swift
//  Photo Map
//
//  Created by Nathan Hays on 12/30/17.
//  Copyright © 2017 Nathan Hays. All rights reserved.
//

import UIKit
import Photos
import GoogleMaps

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, GMSMapViewDelegate {
    
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        view = mapView
    
        Helper.loadPhotos() { (result) -> () in
            self.addMarkers(photos: result)

        }
    }
    
    // Generate Photo Window
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = Bundle.main.loadNibNamed("MarkerView", owner: self.view, options: nil)!.first! as! MarkerUIView
        let uiImage = Helper.getUIImage(asset: marker.userData as! PHAsset)
        infoWindow.photo.image = uiImage
        
        return infoWindow
    }
    
    // Map Info Window was clicked
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let newPhotoController  = self.storyboard?.instantiateViewController(withIdentifier: "LargePhotoViewController") as! LargePhotoViewController
        
        newPhotoController.photoDetail = marker.userData as? PHAsset
        
        self.navigationController!.pushViewController(newPhotoController, animated: true)
    }
    
    private func addMarker(photo : PHAsset) {
        let location = photo.location!
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude))
        marker.userData = photo
        marker.map = mapView
    }
    
    private func addMarkers(photos : PHFetchResult<PHAsset>?) {
        var lat : Double = 0
        var lng : Double = 0
        var count : Double = 0
        photos?.enumerateObjects{(object: AnyObject!,
            index: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in
            
            if object is PHAsset {
                let photo = object as! PHAsset
                if let location = photo.location {
                    lat += location.coordinate.latitude
                    lng += location.coordinate.longitude
                    print(lat, " ", lng)
                    count += 1
                    DispatchQueue.main.async {
                        self.addMarker(photo: photo)
                    }
                    print(count)
                }
            }
            
            if index == photos!.count - 1 {
                lat = lat/count
                lng = lng/count
                let avgCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                DispatchQueue.main.async {
                    let camera = GMSCameraPosition.camera(withTarget: avgCoordinate, zoom: 5.0)
                    self.mapView.animate(to: camera)
                }
            }
        }
    }
}

