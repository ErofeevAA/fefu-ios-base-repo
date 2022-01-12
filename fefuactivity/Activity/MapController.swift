import UIKit
import CoreLocation
import MapKit
import CoreData

class MapController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var processView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var isPaused: Bool = true

    private let coreDataContainer = FEFUCoreDataContainer.instance
    private var timer: Timer?
    private var startTimeForTimer: Date?
    private var previousRouteSegment: MKPolyline?
    private var currentDuration = TimeInterval()

    private var newActivityDate: Date?
    private var newActivityDistance = CLLocationDistance()
    private var newActivityDuration = TimeInterval()
    private var newActivityType: String?
    
    private let activityTypeViewCellID = "ActivityTypeViewCell"
    
    var previousOverlays: [MKOverlay] = []
    
    private let activitiesTypeData: [ActivityTypeCellParams] = [
            ActivityTypeCellParams(type: "Велосипед", title: "На велике"),
            ActivityTypeCellParams(type: "Бег", title: "На пробежке"),
            ActivityTypeCellParams(type: "Космос", title: "На амфетамине")
        ]
    
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
            
            if oldValue != nil {
                newActivityDistance += userLocation.distance(from: oldValue!)
            }
            distanceLabel.text = String(format: "%.2f км", newActivityDistance / 1000)
            mapView.setRegion(region, animated: true)
            userLocationHistory.append(userLocation)
        }
    }
    
    fileprivate var userLocationHistory: [CLLocation] = [] {
            didSet {
                let coordinates = userLocationHistory.map { $0.coordinate }

                if let previousRoute = previousRouteSegment, !userLocationHistory.isEmpty {
                    mapView.removeOverlay(previousRoute as MKOverlay)
                    previousRouteSegment = nil
                }

                if userLocationHistory.isEmpty {
                    previousRouteSegment = nil
                }

                let route = MKPolyline(coordinates: coordinates, count: coordinates.count)

                previousRouteSegment = route

                mapView.addOverlay(route)
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новая активность"
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        pauseButton.setTitle("", for: .normal)
        finishButton.setTitle("", for: .normal)
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: activityTypeViewCellID, bundle: nil), forCellWithReuseIdentifier: activityTypeViewCellID)
        
        previousOverlays = mapView.overlays
        
        newActivityType = "Активность"
        typeLabel.text = newActivityType
    }

    @IBAction func actionPauseButton(_ sender: Any) {
        userLocationHistory = []
        userLocation = nil

        if !isPaused {
            pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            
            newActivityDuration += currentDuration
            currentDuration = TimeInterval()
            timer?.invalidate()
            
            locationManager.stopUpdatingLocation()
        } else {
            pauseButton.setImage(UIImage(named: "ic_pause"), for: .normal)
            
            startTimeForTimer = Date()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdater), userInfo: nil, repeats: true)
            locationManager.startUpdatingLocation()
        }

        isPaused = !isPaused

        newActivityDate = Date()
    }
    
    @IBAction func finishActionButton(_ sender: Any) {
        locationManager.stopUpdatingLocation()

        let context = coreDataContainer.context
        let activity = Activity(context: context)
        
        newActivityDuration += currentDuration
        timer?.invalidate()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let newActivityStartTime = dateFormatter.string(from: newActivityDate!)
        let newActivityEndTime = dateFormatter.string(from: newActivityDate! + newActivityDuration)

        activity.date = newActivityDate
        activity.distance = newActivityDistance
        activity.duration = newActivityDuration
        activity.endTime = newActivityEndTime
        activity.startTime = newActivityStartTime
        activity.type = newActivityType

        coreDataContainer.saveContext()

        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startActionButton(_ sender: Any) {
        startView.isHidden = true
        processView.isHidden = false
        
        isPaused = false

        newActivityDate = Date()
        startTimeForTimer = Date()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdater), userInfo: nil, repeats: true)
        
        locationManager.startUpdatingLocation()
    }
    
    @objc func timerUpdater() {
        let time = Date().timeIntervalSince(startTimeForTimer!)

        currentDuration = time
        let timeFormatter = DateComponentsFormatter()
        timeFormatter.allowedUnits = [.hour, .minute, .second]
        timeFormatter.zeroFormattingBehavior = .pad

        timerLabel.text = timeFormatter.string(from: time + newActivityDuration)
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

extension MapController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activitiesTypeData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newActivityType = activitiesTypeData[indexPath.row]

        let activityTypeCell = collectionView.dequeueReusableCell(withReuseIdentifier: activityTypeViewCellID, for: indexPath)

        guard let cell = activityTypeCell as?
                ActivityTypeViewCell else {
                    return UICollectionViewCell()
        }

        cell.setFields(cell: newActivityType)

        return cell
    }
}

extension MapController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as?
            ActivityTypeViewCell {
            cell.cellView.layer.borderWidth = 2
            cell.cellView.layer.borderColor = UIColor.blue.cgColor

            newActivityType = cell.type
            typeLabel.text = cell.title
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ActivityTypeViewCell {
            cell.cellView.layer.borderColor = UIColor.gray.cgColor
            cell.cellView.layer.borderWidth = 1
        }
    }
}
