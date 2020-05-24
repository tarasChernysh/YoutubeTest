//
//  UIColor+RGB.swift
//  YoutubeTest
//
//  Created by Taras Chernysh on 10/10/19.
//  Copyright © 2019 Taras Chernysh. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(displayP3Red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
