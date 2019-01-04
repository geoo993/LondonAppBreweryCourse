/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import AppCore
import RealmSwift
import AppCoreRealm

class MarksViewController: UITableViewController {

    private var marks: Results<RealmSubjectMark>?
    private class Services: HasMarksService { }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let alert = UIAlertController
        .passwordDialogue(title: "Security Zone", message: "Enter your access pin")
    { [weak self] text in
      self?.loadMarks(text)
    }
    present(alert, animated: true, completion: nil)
  }

  func loadMarks(_ key: String?) {
    guard let key = key else { return }

    do {
        marks = try Services.marksService.getSubjectMarks(key: key)
        tableView.reloadData()
    } catch let error {
        print("Error: \(error)")
        navigationController!.popViewController(animated: true)
    }
  }

  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return marks?.count ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      let mark = marks![indexPath.row]
      cell.textLabel!.text = mark.mark
      cell.detailTextLabel!.text = mark.name
      return cell
  }

    // MARK: - Add results
    @IBAction func addMark(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Add results securely",
                                      message: "Add subject name and your result",
                                      preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addTextField(configurationHandler: nil)

        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {[weak self] action in
            if let subject = alert.textFields?.first?.text,
                !subject.isEmpty,
                let mark = alert.textFields?.last?.text,
                !mark.isEmpty {

                do {
                    try Services.marksService.addSubjectMark(name: subject, mark: mark)
                    self?.tableView.reloadData()
                } catch let error {
                    fatalError("Could not add a subject mark with error: \(error)")
                }

            }
        }))
        present(alert, animated: true, completion: nil)
    }

}
