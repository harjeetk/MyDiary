//
//  String+Extension.swift
//  MyDiary
//
//  Created by Harjeet Singh on 28/11/20.
//

import Foundation
import UIKit

extension String{
    
    public func convertToDate(dateFormat: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: self) ?? Date()
        return date
    }
}
