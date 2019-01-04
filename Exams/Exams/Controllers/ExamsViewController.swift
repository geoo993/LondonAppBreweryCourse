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
import RxSwift
import RealmSwift
import AppCoreRealm

class ExamsViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

    private class Services: HasUserService, HasSubjectService {}
  fileprivate var exams: Results<RealmExam>!

    var bag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    if let _ = SyncUser.current {
        // We have already logged in here!
        getExams()
    } else {
        Services.userService.authUser(name: "geo")
            .asObservable()
            .map({app -> RealmUser in
                // we have logged in
                do {
                    let user =  try Services.userService.addUser(name: "student")
                    return user
                } catch let error {
                    fatalError("Could not set user with error: \(error)")
                }
            })
            .do(onNext: { [weak self] _ in
                do {
                    for subject in Subject.toArray {
                        try Services.subjectService.addSubject(name: subject.rawValue)
                    }
                } catch let error {
                    fatalError("Could not set subject to realm with error: \(error)")
                }

                self?.getExams()
            })
            .subscribe(onNext: { (app) in
            }, onError: { error in
                fatalError(error.localizedDescription)
            }).disposed(by: self.bag)

    }


  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    tableView.reloadData()
  }

    func getExams() {
        do {
            exams = try Services.userService.getExams()
        } catch let error {
            fatalError("Could not get exams from realm with error: \(error)")
        }
    }

}

// MARK: - table data source

extension ExamsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return exams?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as! ExamCell
    let exam = exams[indexPath.row]
    let subject = (try! Services.subjectService.getSubjects().first(where: { $0.uuid == exam.subjectUUID }))!
    cell.configure(with: subject.name, exam: exam)
    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "\(exams?.count ?? 0) exams this semester"
  }
}

// MARK: - table delegate

extension ExamsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
