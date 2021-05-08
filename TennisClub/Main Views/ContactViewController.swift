//
//  ContactViewController.swift
//  TennisClub
//
//  Created by user191625 on 5/8/21.
//

import UIKit
import MapKit

class ContactViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 44.439663, longitude: 26.096306)
        mapView.addAnnotation(annotation)
        annotation.title = "Tennis Club Shop"
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        mapView.setRegion(region, animated: true)
    }
    

}
