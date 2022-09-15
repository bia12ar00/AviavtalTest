//
//  AppoinmentsDataModel.swift
//  aviatal
//
//  Created by Bhavin Kevadia on 15/09/22.
//

import Foundation


struct AppointmentsDataModel: Codable {

    let message: String?
    let data: [AppointmentsDatas]?
    let success: Bool?

    private enum CodingKeys: String, CodingKey {
        case message = "message"
        case data = "data"
        case success = "success"
    }

    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        message = try values?.decodeIfPresent(String.self, forKey: .message)
        data = try values?.decodeIfPresent([AppointmentsDatas].self, forKey: .data)
        success = try values?.decodeIfPresent(Bool.self, forKey: .success)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
        try container.encode(data, forKey: .data)
        try container.encode(success, forKey: .success)
    }

}

struct AppointmentsDatas: Codable {

  
    let Id: String?
    let imageUrl: String?
    let name: String?
    let time: String?

    private enum CodingKeys: String, CodingKey {
        case Id = "_id"
        case imageUrl = "image_url"
        case name = "name"
        case time = "time"
    }

    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        Id = try values?.decodeIfPresent(String.self, forKey: .Id)
        imageUrl = try values?.decodeIfPresent(String.self, forKey: .imageUrl)
        name = try values?.decodeIfPresent(String.self, forKey: .name)
        time = try values?.decodeIfPresent(String.self, forKey: .time)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Id, forKey: .Id)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(name, forKey: .name)
        try container.encode(time, forKey: .time)
    }

}
