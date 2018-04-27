//
//  CLPlacemark+Extension.swift
//  Blind Date
//
//  Created by Praveen Pendyala on 4/26/18.
//  Copyright © 2018 Praveen Pendyala. All rights reserved.
//

import CoreLocation

extension CLPlacemark {
    
    // MARK: -
    // MARK: Public Methods
    
    func getFirebaseDict() -> [AnyHashable: Any] {
        return ["zip" : postalCode ?? "",
               "city" : locality ?? "",
            "country" : country ?? "",
              "state" : administrativeArea ?? ""]
    }
}
