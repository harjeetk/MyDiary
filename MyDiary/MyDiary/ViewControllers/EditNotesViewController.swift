//
//  EditNotesViewController.swift
//  MyDiary
//
//  Created by Harjeet Singh on 28/11/20.
//

import UIKit

protocol EditNotesViewControllerDelegate {
    func noteEdited()
}

class EditNotesViewController: UIViewController {

    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textViewContent: UITextView!
    @IBOutlet weak var buttonEdit: UIButton!
    
    var selectedNotes: MyNotes?
    var delegate: EditNotesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupData()
        setupUI()
        hideKeyboardWhenTappedAround()
    }
    
    fileprivate func setupUI(){
        self.buttonEdit.applyCornerRadius(radius: 5)
    }
    
    fileprivate func setupNavigationBar(){
        let yourBackImage = UIImage(named: "back_button")
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationItem.leftItemsSupplementBackButton = true
        self.title = selectedNotes?.cdTitle
    }
    
    fileprivate func setupData(){
        self.textFieldTitle.text = selectedNotes?.cdTitle
        self.textViewContent.text = selectedNotes?.cdContent
    }
    
    @IBAction func buttonEditTouchUpInside(_ sender: Any) {
        if selectedNotes?.cdTitle != self.textFieldTitle.text || selectedNotes?.cdContent != self.textViewContent.text{//Checks if anything is changed or not
            selectedNotes?.cdTitle = self.textFieldTitle.text
            selectedNotes?.cdContent = self.textViewContent.text
            CoreDBAdaptor.sharedDataAdaptor.updateNotes(note: selectedNotes ?? MyNotes())
            self.delegate?.noteEdited()//Notify list controller that changes has been made and reload the data
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}
