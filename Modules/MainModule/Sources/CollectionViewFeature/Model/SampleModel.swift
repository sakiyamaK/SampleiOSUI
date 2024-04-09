//
//  SampleData.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2020/06/06.
//  Copyright © 2020 sakiyamaK. All rights reserved.
//

import UIKit
import Kingfisher

struct SampleModel: Codable {
    var id: Int
    var title: String? = nil
    var text: String { title ?? "" }
    var iconUrlStr: String? = nil
    var description: String? = nil
}

extension SampleModel {
    static func getDemoData(count: Int) -> [SampleModel] {
        [[SampleModel]](repeating: SampleModel._demoData, count: count).reduce([]) { result, value -> [SampleModel] in
            result + value
        }
    }

    static var demoData: [SampleModel] {
        getDemoData(count: 7)
    }

    private static var _demoData: [SampleModel] {
        let json = """
        [
        {
          "id": 0,
          "title": "タイトル1",
          "iconUrlStr": "https://picsum.photos/200",
          "description": "詳細情報です"
        },
        {
          "id": 1,
          "title": "タイトル2",
          "iconUrlStr": "https://picsum.photos/200/300",
          "description": "詳細情報です\\n詳細情報です\\n詳細情報です\\n詳細情報です\\n詳細情報です"
        },
        {
          "id": 2,
          "title": "タイトル3",
          "iconUrlStr": "https://via.placeholder.com/150/888888/FFFFFF"
        },
        {
          "id": 3,
          "title": "タイトル4",
          "iconUrlStr": "https://via.placeholder.com/150/888888/AAAAAA"
        },
        {
          "id": 4,
          "title": "タイトル5",
          "iconUrlStr": "https://picsum.photos/300"
        },
        {
          "id": 5,
          "title": "タイトル6",
          "iconUrlStr": "https://via.placeholder.com/150/888888/FFAABB"
        },
        {
          "id": 6,
          "title": "タイトル7",
          "iconUrlStr": "https://picsum.photos/400"
        }

        ]
        """.data(using: .utf8)!
        return (try? JSONDecoder().decode([SampleModel].self, from: json)) ?? []
    }
}

struct SampleModel02: Hashable {
    var text: String

    let identifier = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

//    static func == (lhs: Self, rhs: Self) -> Bool {
//        return lhs.identifier == rhs.identifier
//    }

    private static func createSamples(times: Int) -> [Self] {
        Array(0 ... times).map {
            Self(text: $0.description + " desuyo")
        }
    }

    private static func createSampless(times0: Int, times1: Int) -> [[Self]] {
        Array(0 ... times0).map { _ -> [Self] in
            Self.createSamples(times: times1)
        }
    }

    static var samples: [Self] {
        Self.createSamples(times: 100)
    }

    static var sampless: [[Self]] {
        createSampless(times0: 50, times1: 1)
    }

    static var smaple02ss: [[Self]] {
        [Self.createSamples(times: 5), Self.createSamples(times: 10), Self.createSamples(times: 20)]
    }
}

struct SampleModel03: Hashable, Comparable {
    private(set) var color: UIColor
    private(set) var id: Int

    let identifier = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.id < rhs.id
    }

    static func createSamples(times: Int) -> [Self] {
        Array(1 ... times).map { v -> Self in
            let c = UIColor(hue: CGFloat(v) / CGFloat(times), saturation: 1.0, brightness: 1.0, alpha: 1.0)
            return Self(color: c, id: v)
        }.shuffled()
    }
}

struct SampleImageModel: Hashable {
    var image: UIImage?

    static func load(times: Int = 10, completion: (([SampleImageModel]) -> Void)? = nil) {
        var rtn: [SampleImageModel] = []
        (1 ... times).forEach { _ in
            let height = 100 * Int.random(in: 1 ... 3)
            let uuid = UUID().description
            let url = URL(string: "https://picsum.photos/200/\(height)?\(uuid)")!
            let iv = UIImageView()
            iv.kf.setImage(with: url) { _ in
                rtn.append(SampleImageModel(image: iv.image))
                if rtn.count == times {
                    completion?(rtn)
                }
            }
        }
    }
}

struct SampleImageModel2: Hashable {
    var image: UIImage?
    var subImage: UIImage?

    static func load(times: Int = 10, completion: (([Self]) -> Void)? = nil) {
        var rtn: [Self] = []
        (1 ... times).forEach { _ in
            let mainURL = URL(string: "https://picsum.photos/200/300?\(UUID().description)")!
            KingfisherManager.shared.retrieveImage(with: mainURL) { mainResult in
                switch mainResult {
                case let .success(mainSuccess):
                    let subURL = URL(string: "https://picsum.photos/50/50?\(UUID().description)")!
                    KingfisherManager.shared.retrieveImage(with: subURL) { subResult in
                        switch subResult {
                        case let .success(subSuccess):
                            rtn.append(Self(image: mainSuccess.image, subImage: subSuccess.image))
                            if rtn.count == times {
                                completion?(rtn)
                            }
                        case .failure:
                            fatalError()
                        }
                    }
                case .failure:
                    fatalError()
                }
            }
        }
    }
}

struct User {
    var id: Int?
    var name: String?
    var userName: String?
    private var iconURLStr: String?
    var iconURL: URL? {
        guard let iconURLStr = iconURLStr else { return nil }
        return URL(string: iconURLStr)
    }

    static func load(times: Int = 10) -> [Self] {
        (1 ... times).map { _ in
            let id = UUID().hashValue
            let name = "hogehoge"
            let userName = "hoge山ほげ太郎"
            let urlStr = "https://picsum.photos/32?\(UUID().description)"
            return User(id: id, name: name, userName: userName, iconURLStr: urlStr)
        }
    }
}

// struct SampleImageModel03 {
//  var id: Int?
//  var text: String?
//  private var mainImageURLStr: String?
//  var mainImageURL: URL? {
//    guard let mainImageURLStr = mainImageURLStr else { return nil }
//    return URL(string: mainImageURLStr)
//  }
//
//  var user: User
//
//  static func load(times: Int = 10, completion: (([Self]) -> Void)? = nil) {
//    (1 ... times).map { _ in
//
//      let id = UUID().hashValue
//      let text = "hogehoge"
//      let userName = "hoge山ほげ太郎"
//      let urlStr = "https://picsum.photos/32?\(UUID().description)"
//
//      let mainURL = URL(string: "https://picsum.photos/200/300?\(UUID().description)")!
//      KingfisherManager.shared.retrieveImage(with: mainURL) { mainResult in
//        switch mainResult {
//        case let .success(mainSuccess):
//          let subURL = URL(string: "https://picsum.photos/50/50?\(UUID().description)")!
//          KingfisherManager.shared.retrieveImage(with: subURL) { subResult in
//            switch subResult {
//            case let .success(subSuccess):
//              rtn.append(Self(image: mainSuccess.image, subImage: subSuccess.image))
//              if rtn.count == times {
//                completion?(rtn)
//              }
//            case .failure:
//              fatalError()
//            }
//          }
//        case .failure:
//          fatalError()
//        }
//      }
//    }
//  }
// }
