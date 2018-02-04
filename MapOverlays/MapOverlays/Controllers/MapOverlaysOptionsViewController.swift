
import UIKit

public enum MapOverLaysOptionsType: Int {
    case mapBoundary = 0
    case mapOverlay
    case mapPins
    case mapCharacterLocation
    case mapRoute

    public func displayName() -> String {
        switch (self) {
        case .mapBoundary:
          return "Area Boundary"             // polygon
        case .mapOverlay:
          return "Map Overlay"          // image
        case .mapPins:
          return "Attraction Pins"      // Annotation location pin
        case .mapCharacterLocation:
          return "Character Location"   // shape
        case .mapRoute:
          return "Route"                // Polyline 
        }
    }
    
    public static var maxTypes : Int {
        return mapRoute.rawValue + 1
    }
}

public class MapOverlaysOptionsViewController: UIViewController {
    var selectedOptions = [MapOverLaysOptionsType]()
}

// MARK: - UITableViewDataSource
extension MapOverlaysOptionsViewController: UITableViewDataSource {
  
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MapOverLaysOptionsType.maxTypes
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell")!

        if let mapOptionsType = MapOverLaysOptionsType(rawValue: indexPath.row) {
            cell.textLabel!.text = mapOptionsType.displayName()
            cell.accessoryType = selectedOptions.contains(mapOptionsType) ? .checkmark : .none
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension MapOverlaysOptionsViewController: UITableViewDelegate {
  
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        guard let mapOptionsType = MapOverLaysOptionsType(rawValue: indexPath.row) else { return }

        if (cell.accessoryType == .checkmark) {
            // Remove option
            selectedOptions = selectedOptions.filter { $0 != mapOptionsType}
            cell.accessoryType = .none
        } else {
            // Add option
            selectedOptions += [mapOptionsType]
            cell.accessoryType = .checkmark
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
