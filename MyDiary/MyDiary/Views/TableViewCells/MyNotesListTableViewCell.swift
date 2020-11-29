//
//  MyNotesListTableViewCell.swift
//  MyDiary
//
//  Created by Harjeet Singh on 28/11/20.
//

import UIKit

class MyNotesListTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var buttonDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    fileprivate func setupUI(){
        containerView.applyCornerRadius(radius: 4)
        containerView.applyShadow(color: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.08), opacity: 1, radius: 5)
        viewDelete.roundedView()
        viewDelete.applyShadow(color: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1), opacity: 1, radius: 3)
    }
    
    
    func setMyNotesData(Where note: MyNotes){
        labelTitle.text = note.cdTitle
        labelContent.attributedText = self.setupContentAttributedString(text: note.cdContent ?? "")
        labelTime.text = note.cdDate?.convertToDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").getElapsedInterval()
    }
    
    fileprivate func setupContentAttributedString(text: String) -> NSAttributedString?{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        let attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return attributedText
    }
    
    static var registerNib = UINib(nibName: MyNotesListTableViewCell.reuseIdentifier, bundle: nil)
}
