//
//  SwiftUIView.swift
//  SampleCollectionView
//
//  Created by sakiyamaK on 2021/11/03.
//  Copyright © 2021 sakiyamaK. All rights reserved.
//

import SwiftUI

struct SwiftUICollectionViewCell1View: HostingCellContent {
    typealias Dependency = SwiftUICollectionViewCell1ViewDependency

    struct SwiftUICollectionViewCell1ViewDependency {
        var text: String
        var subText: String
    }

    var dependency: SwiftUICollectionViewCell1ViewDependency

    init(_ dependency: SwiftUICollectionViewCell1ViewDependency) {
        self.dependency = dependency
    }

    var body: some View {
        VStack(spacing: 10) {
            Text(dependency.text)
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(dependency.subText)
                .font(.system(size: 12, weight: .regular))
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer(minLength: 10)
        }
        .padding(12)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUICollectionViewCell1View(.init(text: "hoge", subText: "hage"))
            .previewLayout(.fixed(width: 200, height: 100))
    }
}
