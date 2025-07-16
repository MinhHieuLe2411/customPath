//
//  BottomStackItem.swift
//  CustomPath
//
//  Created by MinhHieu on 10/02/2025.
//

import Foundation
import UIKit

class BottomStackItem {
    
    var title: String
    var image: String
    var isSelected: Bool
    
    init(title: String,
         image: String,
         isSelected: Bool = false) {
        self.title = title
        self.image = image
        self.isSelected = isSelected
    }
    
}
