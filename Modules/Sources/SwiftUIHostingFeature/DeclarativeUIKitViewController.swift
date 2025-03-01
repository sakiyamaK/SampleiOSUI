//
//  DeclarativeUIKitViewController.swift
//  Modules
//
//  Created by sakiyamaK on 2025/02/28.
//

import UIKit
import SwiftUI
import SwiftData
import DeclarativeUIKit
import ObservableUIKit

public extension Locale {
    static var `default`: Locale { Locale.enUSPosix }
    static var jaJP: Locale { Locale(identifier: "ja_JP") }
    static var enUSPosix: Locale { Locale(identifier: "en_US_POSIX") }
}

public extension TimeZone {
    static var `default`: TimeZone {
        TimeZone(identifier: "Asia/Tokyo")!
    }
}

public extension Calendar {
    static var `default`: Calendar {
        Calendar(identifier: .gregorian)
    }
}

public extension DateFormatter {
    static func ymdEHm(containsDay: Bool = true, locale: Locale = .default, timeZone: TimeZone = .default) -> DateFormatter {
        let df = DateFormatter()
        df.calendar = .default
        df.timeZone = timeZone
        df.dateFormat = containsDay ? "yyyy.MM.dd(EEE) HH:mm" : "HH:mm"
        df.locale = locale
        return df
    }
}

extension View {
    var hostingConfiguration: UIHostingConfiguration<Self, some View> {
        UIHostingConfiguration {
            self
        }
    }
}

// 抽象的なObservableClassを用意
@Observable
class ObservableClass {
}

@Observable
final class Counter: ObservableClass {
    var count: Int = 0
    init(count: Int) {
        self.count = count
    }
}

// 汎用的なSwiftUIViewを用意
struct SwiftUIView<Content: View>: View {
    var bind: ObservableClass
    var bodyBuilder: () -> Content

    var body: some View {
        let _: ObservableClass = bind
        bodyBuilder()
    }
}

extension View {
    func environment(_ observableClass: ObservableClass) -> some View {
        SwiftUIView(bind: observableClass) {
            self
        }
    }
}

final class DeclarativeUIKitViewController: UIViewController {

    private var counter = Counter(count: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        let date = DateFormatter.ymdEHm().date(from: "2023-11-29T00:00:00+0900") ?? Date()
        let dateStr = DateFormatter.ymdEHm(locale: .jaJP).string(from: date)

        applyView {
            $0.backgroundColor(.systemBackground)
        }.declarative { [unowned self] in
            UIStackView(spacing: 8) {
                UIStackView.horizontal(spacing: 8) {
                    UILabel(dateStr)
                    UILabel()
                        .tracking { [weak self] in
                            self?.counter.count
                        } onChange: { label, count in
                            label.text = "\(count)"
                        }
                }

                SwiftUIView(bind: self.counter) {
                    VStack(spacing: 8) {
                        HStack {
                            Text("SwiftUI.Text")
                            Text(self.counter.count.description)

                        }
                        Button("Count Up SwiftUI.Button") {
                            self.counter.count += 1
                        }
                    }
                }
                .hostingConfiguration.makeContentView()
            }
            .alignment(.center)
            .center()

        }
    }
}

#Preview {
    DeclarativeUIKitViewController()
}

