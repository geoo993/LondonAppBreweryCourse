import Foundation
import UIKit

public extension UITableView {
    
    public func getAllCells() -> [UITableViewCell] {
        
        var cells = [UITableViewCell]()
        // assuming tableView is your self.tableView defined somewhere
        for i in 0..<self.numberOfSections
        {
            for j in 0..<self.numberOfRows(inSection:i)
            {
                if let cell = self.cellForRow(at: IndexPath(row: j, section: i) ) {
                    
                    cells.append(cell)
                }
                
            }
        }
        return cells
    }
    
}
