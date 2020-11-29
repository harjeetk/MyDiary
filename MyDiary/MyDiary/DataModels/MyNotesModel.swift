//
//  MyNotesModel.swift
//  MyDiary
//
//  Created by Harjeet Singh on 28/11/20.
//

import Foundation

struct MyNotesRecord: Codable {
    
    enum CodingKeys: String, CodingKey{
        case id, title, content, date
    }
    
    var id: String?
    var title: String?
    var content: String?
    var date: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        content = try container.decodeIfPresent(String.self, forKey: .content)
        date = try container.decodeIfPresent(String.self, forKey: .date)
    }
}
