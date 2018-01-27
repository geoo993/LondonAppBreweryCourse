
// https://www.captechconsulting.com/blogs/arkit-fundamentals-in-ios-11

import UIKit
import ARKit
import Chameleon

private let CellIdentifier = "Cell"

private struct Option {
    let title: String
    let vc: UIViewController.Type
}

public class ARPrimitivesViewController: UITableViewController {
    
    private var options: [Option] = []
    let selectedColor : UIColor = .random

    func updateNavBar (with color : UIColor) {
        if let navController = navigationController {
            let constrastColor = ContrastColorOf(color, returnFlat: true)
            // items color
            navController.navigationBar.tintColor = constrastColor
            
            // background color
            navController.navigationBar.barTintColor = color
            
            // text color
            navController.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: constrastColor]
        }
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ARKit Demo"
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        self.tableView.separatorStyle = .none
        
        self.options = [
            Option(title: "Shape", vc: SimpleShapeViewController.self),
            Option(title: "Lines", vc: LineDrawerViewController.self),
            Option(title: "Thick Lines", vc: ARDrawingViewController.self),
            Option(title: "Toss Shape", vc: TossShapeViewController.self),
            Option(title: "Plane Mapper", vc: PlaneMapperViewController.self),
            Option(title: "Tea Cup", vc: PlaneAnchorViewController.self),
            Option(title: "Solar System", vc: SolarSystemsViewController.self)
        ]
        
        updateNavBar(with: selectedColor)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !ARConfiguration.isSupported {
            let alert = UIAlertController(title: "Device Requirement", message: "Sorry, this app only runs on devices that support augmented reality through ARKit.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        
        
        let numberOfTodoItems = self.options.count
        
        cell.backgroundColor =  selectedColor.darken(byPercentage: 
                (CGFloat(indexPath.row) / CGFloat(numberOfTodoItems)) )
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor ?? .white, returnFlat: true)
      
        cell.textLabel?.text = self.options[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vcType = self.options[indexPath.row].vc
        let vc = vcType.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

