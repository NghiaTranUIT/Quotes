//
//  String+Substring.swift
//  Quotes
//
//  Created by Tomasz Szulc on 09/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation

extension String {
    func excerpt(length: Int) -> String {
        return self.substringWithRange(Range(start: startIndex, end: advance(startIndex, length)))
    }
}