//
//  UITableView+Extension.swift
//  MyDiary
//
//  Created by Harjeet Singh on 28/11/20.
//

import Foundation
import UIKit

extension UITableView{
    
    func reloadWithAnimation(){
        UIView.transition(with: self,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: { self.reloadData() })
    }
}
