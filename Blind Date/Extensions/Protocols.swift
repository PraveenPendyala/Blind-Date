//
//  Protocols.swift
//  Blind Date
//
//  Created by Praveen Pendyala on 5/23/18.
//  Copyright © 2018 Praveen Pendyala. All rights reserved.
//

import UIKit

protocol StoryboardInitializable where Self: UIViewController {
    static func instantiateFromStoryboard() -> Self
}
