//
//  AsyncValueView.swift
//  Modules
//
//  Created by sakiyamaK on 2025/01/22.
//


import SwiftUI

@Observable
@MainActor
final class AsyncValue<T: Sendable> {
    private var _value: T?
    private var _laoding: Bool = false
    private var _error: Error?

    enum State {
        case asyncData(T)
        case asyncError(Error)
        case asyncLoading
    }

    var state: State = .asyncLoading

    init(_ value: @escaping () async throws -> T) {
        observation(value)
        Task {
            do {
                self._error = nil
                self._laoding = true
                self._value = try await value()
                self._laoding = false
            } catch let e {
                self._error = e
            }
        }
    }

    private func observation(_ asyncValue: @escaping () async throws -> T) {

        _ = withObservationTracking {[weak self] in
            self!._value
        } onChange: {[weak self] in
            Task { @MainActor in
                guard let value = self!._value else { return }
                self!.state = .asyncData(value)
                self!.observation(asyncValue)
            }
        }

        _ = withObservationTracking {[weak self] in
            self!._laoding
        } onChange: {[weak self] in
            Task { @MainActor in
                guard self!._laoding else { return }
                self!.state = .asyncLoading
                self!.observation(asyncValue)
            }
        }

        _ = withObservationTracking {[weak self] in
            self!._error
        } onChange: {[weak self] in
            Task { @MainActor in
                guard let error = self!._error else { return }
                self!.state = .asyncError(error)
                self!.observation(asyncValue)
            }
        }
    }
}

struct AsyncValueView: View {
    @State var asyncValue = AsyncValue {
        try await Task.sleep(for: .seconds(5))
        return try await URLSession.shared.data(from: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!)
    }

    var body: some View {
        switch asyncValue.state {
        case .asyncLoading:
            ProgressView("Loading...")
        case .asyncData(let value):
            Text("Data: \(value)")
        case .asyncError(let error):
            VStack {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    AsyncValueView()
}
