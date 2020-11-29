//
//  MyNotesHeaderView.swift
//  MyDiary
//
//  Created by Harjeet Singh on 28/11/20.
//

import UIKit

class MyNotesHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var labelDate: UILabel!
    static var registerNib = UINib.init(nibName: MyNotesHeaderView.reuseIdentifier, bundle: Bundle.main)
}
