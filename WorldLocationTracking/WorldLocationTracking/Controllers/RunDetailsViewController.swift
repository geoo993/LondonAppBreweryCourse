
// https://www.raywenderlich.com/155772/make-app-like-runkeeper-part-1-2

import UIKit
import MapKit
import AppCore

public class RunDetailsViewController: UIViewController {
  
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!

    var run: Run!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        loadMap()
    }

    private func configureView() {
        let distance = Measurement(value: run.distance, unit: UnitLength.meters)
        let seconds = Int(run.duration)
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedDate = FormatDisplay.date(run.timestamp)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance, 
                                               seconds: seconds, 
                                               outputUnit: UnitSpeed.minutesPerMile)
        
        distanceLabel.text = "Distance:  \(formattedDistance)"
        dateLabel.text = formattedDate
        timeLabel.text = "Time:  \(formattedTime)"
        paceLabel.text = "Pace:  \(formattedPace)"
    }
    
    private func loadMap() {
        guard
            let locations = run.locations,
            locations.count > 0,
            let region = mapRegion()
            else {
                let alert = UIAlertController(title: "Error",
                                              message: "Sorry, this run has no locations saved",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
                return
        }
        
        mapView.setRegion(region, animated: true)
        //mapView.add(polyLine())
        mapView.addOverlays(multicolorPolyline())
    }
    
    private func mapRegion() -> MKCoordinateRegion? {
        guard
            let locations = run.locations,
            locations.count > 0
            else {
                return nil
        }
        
        let latitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.latitude
        }
        
        let longitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.longitude
        }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        // center from the list of location
        return MKCoordinateRegion(center: center, span: span) 
    }
    
    private func polyLine() -> MKPolyline {
        guard let locations = run.locations else {
            return MKPolyline()
        }
        
        let coords: [CLLocationCoordinate2D] = locations.map { location in
            let location = location as! Location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    private func multicolorPolyline() -> [MulticolorPolyline] {
        
        // 1
        let locations = run.locations?.array as! [Location]
        var coordinates: [(CLLocation, CLLocation)] = []
        var speeds: [Double] = []
        var minSpeed = Double.greatestFiniteMagnitude
        var maxSpeed = 0.0
        
        // 2
        for (first, second) in zip(locations, locations.dropFirst()) {
            let start = CLLocation(latitude: first.latitude, longitude: first.longitude)
            let end = CLLocation(latitude: second.latitude, longitude: second.longitude)
            coordinates.append((start, end))
            
            //3
            let distance = end.distance(from: start)
            let time = second.timestamp!.timeIntervalSince(first.timestamp! as Date)
            let speed = time > 0 ? distance / time : 0
            speeds.append(speed)
            minSpeed = min(minSpeed, speed)
            maxSpeed = max(maxSpeed, speed)
        }
        
        //4
        let midSpeed = speeds.reduce(0, +) / Double(speeds.count)
        
        //5
        var segments: [MulticolorPolyline] = []
        for ((start, end), speed) in zip(coordinates, speeds) {
            let coords = [start.coordinate, end.coordinate]
            let segment = MulticolorPolyline(coordinates: coords, count: 2)
            segment.color = UIColor.segmentColor(speed: speed,
                                                 midSpeed: midSpeed,
                                                 slowestSpeed: minSpeed,
                                                 fastestSpeed: maxSpeed)
            segments.append(segment)
        }
        return segments
    }
    
}

extension RunDetailsViewController: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MulticolorPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = polyline.color // .black
        renderer.lineWidth = 4
        
        return renderer
    }
}

