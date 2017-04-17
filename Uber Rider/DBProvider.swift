//
//  DBProvider.swift
//  Uber Rider
//
//  Created by Evan Latner on 4/17/17.
//  Copyright © 2017 levellabs. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBProvider {
    private static let _instance = DBProvider()
    static var Instance: DBProvider {
        return _instance
    }

    var dbRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }

    var ridersRef: FIRDatabaseReference {
        return dbRef.child(Constants.RIDERS)
    }
    
    func saveUserToDB(id: String, email: String, password: String) {
        let data: Dictionary<String, Any> = [Constants.EMAIL : email, Constants.PASSWORD : password, Constants.isRider : true]
        
        ridersRef.child(id).child(Constants.DATA).setValue(data)
    }
}
