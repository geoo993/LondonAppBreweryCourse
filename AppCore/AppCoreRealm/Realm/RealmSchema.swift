//
//  RealmUserSchema.swift
//  ProjectStemView
//
//  Created by GEORGE QUENTIN on 05/08/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

public class RealmUserSchema: SchemaManaging {

    public static var objectTypes: [RealmSwift.Object.Type] {
        return [RealmApp.self,
                RealmUser.self,
                RealmMessage.self,
                RealmExam.self,
                RealmStatus.self,
        ]
    }

}

public class RealmSubjectsSchema: SchemaManaging {

    public static var objectTypes: [RealmSwift.Object.Type] {
        return [
            RealmSubject.self
        ]
    }
}

public class RealmMarksSchema: SchemaManaging {

    public static var objectTypes: [RealmSwift.Object.Type] {
        return [
            RealmSubjectMark.self
        ]
    }
}
