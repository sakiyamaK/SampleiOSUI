// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit
import SwiftUI
import RswiftResources

public extension RswiftResources.ImageResource {
    var aho: RswiftResources.ImageResource {
        R.image(bundle: .module).aho
    }
}

public extension _R {
    var otherPackage: OtherPackage { OtherPackage() }
    struct OtherPackage {
        public var image: _R.image {
            R.image(bundle: .module)
        }
    }
}


struct MySwiftUIView: View {
    var body: some View {
        Image(R.image(bundle: .module).aho)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

#Preview {
    MySwiftUIView()
}



