//
//  ThemeProtocol.swift
//  GetToThings
//
//  Created by Logan Pfahler on 11/13/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit

protocol ThemeProtocol {
    var mainFontName: String { get }
    var accent: UIColor { get }
    var background: UIColor { get }
    var tint: UIColor { get }
}
