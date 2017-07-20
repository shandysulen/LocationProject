//
//  ViewController.swift
//  LocationProject
//
//  Created by Shandy Sulen on 7/19/17.
//  Copyright © 2017 Shandy Sulen. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
   
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var latitudeNumericalLabel: UILabel!
   
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var longitudeNumericalLabel: UILabel!
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedNumericalLabel: UILabel!
    
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var altitudeNumericalLabel: UILabel!
    
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var courseNumericalLabel: UILabel!
    
    
    @IBOutlet weak var locateMeButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = 5
        
        latitudeLabel.text = "Latitude:"
        longitudeLabel.text = "Longitude:"
        speedLabel.text = "Speed:"
        altitudeLabel.text = "Altitude:"
        courseLabel.text = "Course:"
        
        locateMeButton.setTitle("Locate Me!", for: .normal)
        
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        print(status)
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            // boo-hoo... show an error
            showError(withTitle: "No Location Data", andMessage: "You denied access to your location... so we are not able to show you any data...")
            break
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController {
    
    func showError(withTitle title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK 😱", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // we'll do stuff...
        // when we get the location, ONLY THEN we want to get weather data
        print(locations.last)
        guard let location = locations.last else { return }
        
        latitudeNumericalLabel.text = "\(location.coordinate.latitude)"
        longitudeNumericalLabel.text = "\(location.coordinate.longitude)"
        speedNumericalLabel.text = "\(location.speed)"
        altitudeNumericalLabel.text = "\(location.altitude)"
        courseNumericalLabel.text = "\(location.course)"
//        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // we'll do stuff...
        showError(withTitle: "Error!", andMessage: "Something happened, and we don't know what...")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            // show error
            showError(withTitle: "No Location Data", andMessage: "You denied access to your location... so we are not able to show you any data...")
        }
    }
}


