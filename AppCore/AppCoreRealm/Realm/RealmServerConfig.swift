//
//  RealmObjectServerConfig.swift
//  StoryRealm
//
//  Created by Daniel Asher on 14/06/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//
// https://docs.realm.io/platform/v/3.x/getting-started-1/ios-quick-start/step-1-my-first-realm-app
// https://docs.realm.io/platform/v/3.x/getting-started-1/ios-quick-start
// https://realm.io/docs/swift/latest/#troubleshooting
// https://docs.realm.io/platform/self-hosted/installation
// https://aws.amazon.com/premiumsupport/knowledge-center/ec2-linux-ssh-troubleshooting/
// https://aws.amazon.com/premiumsupport/knowledge-center/connect-http-https-ec2/
// https://stackoverflow.com/questions/28465706/how-to-find-my-realm-file/28465803#28465803
// https://stackoverflow.com/questions/40571215/i-dont-understand-how-to-get-the-realm-server-running-on-the-aws-ami

import Foundation
import RealmSwift

public enum RealmError: Error {
    case loginTimeout(Error?)
    case writeAppError(Error?)
    case incorrectArgumentType
    case currentUserUnavailable
    case currentAppInvalid
    case currentUserInvalid
    case userRealmUnavailable
    case userRealmNotSet
    case subjectRealmUnavailable
    case marksRealmUnavailable
    case realmUnavailable(Realm.Configuration)
    case networkUnavailable
}

public struct RealmServerConfig {
    struct Constants {

        // **** Realm Cloud Users:
        // **** Replace MY_INSTANCE_ADDRESS with the hostname of your cloud instance
        // **** e.g., "mycoolapp.us1.cloud.realm.io"
        // ****
        // ****
        // **** ROS On-Premises Users
        // **** Replace the AUTH_URL and REALM_URL strings with the fully qualified versions of
        // **** address of your ROS server, e.g.: "http://127.0.0.1:9080" and "realm://127.0.0.1:9080"

        static let MY_INSTANCE_ADDRESS = "projectstem.de1a.cloud.realm.io" // <- update this

        static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
        static let USER_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/~/user")!
        static let SUBJECTS_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/subjects")!
        static let MARKS_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/marks")!
    }

}
