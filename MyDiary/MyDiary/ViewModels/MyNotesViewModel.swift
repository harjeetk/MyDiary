//
//  MyNotesViewModel.swift
//  MyDiary
//
//  Created by Harjeet Singh on 28/11/20.
//

import Foundation

class MyNotesViewModel{
    
    var arrayNotes = [[MyNotes]]()
    
    init() {
        
    }
    
    func setMyNotesHeaderView(Where headerView: MyNotesHeaderView, section: Int){
        let sectionNotes = arrayNotes[section].first
        headerView.labelDate.text = sectionNotes?.cdDate?.convertToDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").getDateStringElapsed()
    }
    
    func setMyNotesListCell(Where cell: MyNotesListTableViewCell, indexPath: IndexPath){
        let myNote = arrayNotes[indexPath.section][indexPath.row]
        cell.setMyNotesData(Where: myNote)
    }
    
    func fetchMyNotes(handler: @escaping(Bool, String) -> Void){
        let myNotes = CoreDBAdaptor.sharedDataAdaptor.fetchAllNotes() //Get Data from coredata
        if myNotes.count > 0{ //Check if present then load from coredata
            let notes = myNotes
            self.arrayNotes = self.groupNotesToDates(arrayMessages: notes)
            handler(true, "Fetched from core data")
        }else{//Call Webservice if not found in coredata
            if Reachability.isConnectedToNetwork(){
                let url = URL(string: "https://private-ba0842-gary23.apiary-mock.com/notes")
                guard let requestUrl = url else {return handler(false, "Unable to contact the server")}
                var request = URLRequest(url: requestUrl)
                // Specify HTTP Method to use
                request.httpMethod = "GET"
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                // Send HTTP Request
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    guard let data = data else { return handler(false, error?.localizedDescription ?? "Unable to contact the server")}
                    do {
                        var returnValue: [MyNotesRecord]?
                        let decoder = JSONDecoder()
                        returnValue = try decoder.decode([MyNotesRecord].self, from: data)
                        let notes = CoreDBAdaptor.sharedDataAdaptor.saveNotes(returnValue ?? [])//Save in coredata
                        self.arrayNotes = self.groupNotesToDates(arrayMessages: notes) //Fetch from coredata and sort them according to the date
                        handler(true, "Fetched from API")
                    } catch {
                        handler(false, "Couldn't parse as \(MyNotesRecord.self):\n\(error)")
                    }
                }
                task.resume()
            }else{
                handler(false, "Network error")
            }
        }
    }
    
    //Divides the array data into the form of key,value where key is the date and value which belongs to that key
    func groupNotesToDates(arrayMessages: [MyNotes]) -> [[MyNotes]]{
        let groupMessages = Dictionary.init(grouping: arrayMessages) { (element) -> String in
            let value = (element.cdDate?.convertToDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").toString(format: "yyyy-MM-dd")) ?? ""
            return value
        }
        return sortArray(array: groupMessages)
    }
    
    //Sort the keys and value inside according to the recent
    func sortArray(array: [String: [MyNotes]]) -> [[MyNotes]]{
        var sortedKeys = array.keys.sorted()
        sortedKeys.reverse()
        var arrayGroupMessage = [[MyNotes]]()
        sortedKeys.forEach { (key) in
            let values = array[key]?.sorted(by: { ($0.cdDate ?? "") > ($1.cdDate ?? "") })
            arrayGroupMessage.append(values ?? [])
        }
        return arrayGroupMessage
    }
}
