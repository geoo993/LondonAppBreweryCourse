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
import RealmSwift
import AppCore
import AppCoreRealm

class FavoritesTableViewController: UITableViewController {

    private class Services: HasUserService {}
    fileprivate var messages: Results<RealmMessage>!
    private var messagesToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        setMessagesFavorites()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if messages == nil {
            setMessagesFavorites()
        }
        updateNotification()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        messagesToken?.invalidate()
    }

    func setMessagesFavorites() {
        do {
            let user = try Services.userService.defaultUser()
            messages = user.messages.filter("isFavorite = true")
        } catch let error {
            print("could not get user with error: \(error)")
        }

    }

    func updateNotification() {
        messagesToken = messages?.observe { [weak self] changes  in
            guard let tableView = self?.tableView else { return }

            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let updates):
                // Query results have changed, so apply them to the UITableView
                tableView.applyChanges(section: 0, deletions: deletions, insertions: insertions, updates: updates)
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                print("could not correct tableView \(error)")
                break
            }
        }
    }

    // MARK: - table view methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.reuseIdentifier,
                                                 for: indexPath) as! FeedTableViewCell
        let message = messages[indexPath.row]
        cell.configureWithMessage(message)

        return cell
    }

}

