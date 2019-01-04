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
import Kingfisher
import AppCoreRealm

class ProfileViewController: UIViewController {

    private class Services: HasUserService {}

    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var signOut: UIButton!
    @IBOutlet weak var statsLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!

    private var user: RealmUser!
    private var userToken: NotificationToken?
    private var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let user = try Services.userService.defaultUser()
            userToken = user.observe { [weak self] change in
                switch change {
                case .change(let properties):
                    if let index = properties.index(where: { $0.name == "sent" }),
                        let nr = properties[index].newValue as? Int {
                        self?.updateUI(messageCount: nr)
                    }
                default: break
                }
            }
            updateUI(messageCount: user.sent)
        } catch let error {
            print("could not get user with error: \(error)")
        }

        photo.kf.setImage(with: imageUrlForName("me"))
    }

    @IBAction func signInTap() {
        func enableSignOut() {
            self.signOut.isEnabled = true
            self.signOut.isHidden = false
            self.signIn.isEnabled = !self.signOut.isEnabled
            self.signIn.isHidden = !self.signOut.isHidden
        }
        if let _ = SyncUser.current {
            // We have already logged in here!
            enableSignOut()
        } else {
            let alertController = UIAlertController(title: "Login to Realm Cloud", message: "Supply a nice nickname!", preferredStyle: .alert)

            alertController.addAction(UIAlertAction(title: "Login", style: .default, handler: { [unowned self]
                alert -> Void in
                let textField = alertController.textFields![0] as UITextField

                Services.userService.authUser(name: "geo")
                    .asObservable()
                    .map({ app -> RealmUser in
                        // we have logged in
                        do {
                            let user =  try Services.userService.addUser(name: textField.text!)
                            self.setMessages(user: user)
                            return user
                        } catch let error {
                            fatalError("Could not set user with error: \(error)")
                        }
                    })
                    .subscribe(onNext: { (app) in
                        enableSignOut()
                    }, onError: { error in
                        fatalError(error.localizedDescription)
                    }).disposed(by: self.bag)

            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
                textField.placeholder = "A Name for your user"
            })
            self.present(alertController, animated: true, completion: nil)
        }

    }

    @IBAction func signOutTap() {
        func enableSignIn() {
            self.signIn.isEnabled = true
            self.signIn.isHidden = false
            self.signOut.isEnabled = !self.signIn.isEnabled
            self.signOut.isHidden = !self.signIn.isHidden
        }
        let alertController = UIAlertController(title: "Logout", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes, Logout", style: .destructive, handler: {
            alert -> Void in
            SyncUser.current?.logOut()
            enableSignIn()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)

    }

    func setMessages(user: RealmUser) {
        if let controllers = self.tabBarController?.viewControllers {
            for controller in controllers {
                switch controller {
                case let feed as FeedTableViewController:
                    feed.setMessages()
                case let favorite as FavoritesTableViewController:
                    favorite.setMessagesFavorites()
                default: break
                }
            }
        }
    }

    private func updateUI(messageCount: Int) {
        statsLabel.text = "\(messageCount) sent messages"
    }
}
