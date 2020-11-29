//
//  MyNotesViewController.swift
//  MyDiary
//
//  Created by Harjeet Singh on 28/11/20.
//

import UIKit

class MyNotesViewController: UIViewController {

    @IBOutlet var tableViewMyNotes: UITableView!
    
    var viewModel =  MyNotesViewModel()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingIndicator()
        getData()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    fileprivate func setupTableView(){
        tableViewMyNotes.register(MyNotesListTableViewCell.registerNib, forCellReuseIdentifier: MyNotesListTableViewCell.reuseIdentifier)
        tableViewMyNotes.register(MyNotesHeaderView.registerNib, forHeaderFooterViewReuseIdentifier: MyNotesHeaderView.reuseIdentifier)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableViewMyNotes.addSubview(refreshControl)
        tableViewMyNotes.contentInset = UIEdgeInsets(top: 15.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableViewMyNotes.separatorStyle = .none
        tableViewMyNotes.delegate = self
        tableViewMyNotes.dataSource = self
        tableViewMyNotes.reloadWithAnimation()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.getData()
    }
    
    fileprivate func getData(){
        self.viewModel.fetchMyNotes { [weak self] (isSuccess, message) in
            guard let `self` = self else{return}
            DispatchQueue.main.async {
                self.hideIndicator()
                self.refreshControl.endRefreshing()
                if isSuccess{
                    self.tableViewMyNotes.reloadWithAnimation()
                }else{
                    self.showAlert(title: "Error", message: message)
                }
            }
        }
    }
    
    fileprivate func setupNavigationBar(){
        self.title = "My Diary"
    }
    
    @IBAction func buttonEditTouchUpInside(_ sender: UIButton){
        let index = sender.tag
        let section = Int(sender.accessibilityHint ?? "0")
        self.title = ""
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditNotesViewController") as! EditNotesViewController
        controller.selectedNotes = self.viewModel.arrayNotes[section ?? 0][index]
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func buttonDeleteTouchUpInside(_ sender: UIButton){
        let index = sender.tag
        let section = Int(sender.accessibilityHint ?? "0")
        CoreDBAdaptor.sharedDataAdaptor.deleteNotesWhere(note: self.viewModel.arrayNotes[section ?? 0][index])
        getData()
    }
}

//MARK: - Delegate method to know if notes has been edited
extension MyNotesViewController: EditNotesViewControllerDelegate{
    func noteEdited() {
        self.getData()
    }
}

extension MyNotesViewController: UITableViewDelegate{
    
}

extension MyNotesViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.arrayNotes.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyNotesHeaderView.reuseIdentifier) as! MyNotesHeaderView
        viewModel.setMyNotesHeaderView(Where: headerView, section: section)
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.arrayNotes[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyNotesListTableViewCell.reuseIdentifier, for: indexPath) as! MyNotesListTableViewCell
        self.viewModel.setMyNotesListCell(Where: cell, indexPath: indexPath)
        cell.buttonEdit.tag = indexPath.row
        cell.buttonEdit.accessibilityHint = "\(indexPath.section)"
        cell.buttonEdit.addTarget(self, action: #selector(self.buttonEditTouchUpInside(_:)), for: .touchUpInside)
        cell.buttonDelete.tag = indexPath.row
        cell.buttonDelete.accessibilityHint = "\(indexPath.section)"
        cell.buttonDelete.addTarget(self, action: #selector(self.buttonDeleteTouchUpInside(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

