import UIKit
import CoreLocation
import MapKit


class MapController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var previousOverlays: [MKOverlay] = []
    
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        return manager
    }()
    
    var userLocation: CLLocation? {
        didSet {
            guard let userLocation = userLocation else {
                return
            }
            let region =  MKCoordinateRegion(center: userLocation.coordinate,
                                            latitudinalMeters: 500,
                                            longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
            userLocationHistory.append(userLocation)
        }
    }
    
    fileprivate var userLocationHistory: [CLLocation] = [] {
        didSet {
            let coordinates = userLocationHistory.map { $0.coordinate }
            let route = MKPolyline(coordinates: coordinates, count: coordinates.count)
            route.title = "Ваш маршрут"
            for overlay in previousOverlays {
                mapView.removeOverlay(overlay)
                previousOverlays.remove(at: 0)
            }
            mapView.addOverlay(route)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новая активность"
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        previousOverlays = mapView.overlays
    }

}

extension MapController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {
            return
        }
        userLocation = currentLocation
    }
}

extension MapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let render = MKPolylineRenderer(polyline: polyline)
            render.fillColor = UIColor.blue
            render.strokeColor = UIColor.blue
            render.lineWidth = 5
            return render
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let id = "location_user_icon"
        if let annotation = annotation as? MKUserLocation {
            let dequeView = mapView.dequeueReusableAnnotationView(withIdentifier: id)
            let view = dequeView ?? MKAnnotationView(annotation: annotation, reuseIdentifier: id)
            view.image = UIImage(named: "ic_user_location")
            return view
        }
        return nil
    }
}
