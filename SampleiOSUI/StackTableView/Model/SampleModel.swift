//
//  SampleModel.swift
//  SampleiOSUI
//
//  Created by sakiyamaK on 2021/03/16.
//

import Foundation

struct SampleModel: Codable {
    var name: String
    var description: String

    static var samples: [SampleModel] {
        Array(100...200).map {
            SampleModel(name: $0.description + "desuyo", description: $0.description + "\n" + $0.description + "\n" + $0.description + "\n" + $0.description)
        }
    }
}
