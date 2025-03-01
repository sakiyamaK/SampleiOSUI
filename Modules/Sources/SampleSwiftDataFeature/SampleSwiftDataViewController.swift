import UIKit
import SwiftData
import DeclarativeUIKit
import ObservableUIKit
import Utils

extension UIStackView {

    convenience init(axis: NSLayoutConstraint.Axis = .vertical, alignment: Alignment = .fill, distribution: Distribution = .fill, spacing: CGFloat = 0.0) {
        self.init(frame: .zero)
        self.backgroundColor = .clear
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }

    @discardableResult
    func removeAllArrangedSubviews() -> Self {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        return self
    }
}

@Observable
@MainActor
public final class SampleSwiftDataViewModel {
    private var modelContainer: ModelContainer!
    private var modelContext: ModelContext!
    private(set) var items: [Item] = []

    deinit {
        DLog()
         NotificationCenter.default.removeObserver(self)
     }

    public init() {
        self.modelContainer = try! ModelContainer(
            for: Schema([Item.self]),
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )
        self.modelContext = self.modelContainer.mainContext
        NotificationCenter.default.addObserver(
            forName: ModelContext.didSave,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.items = (try? self?.modelContext
                    .fetch(
                        FetchDescriptor<Item>(
                            sortBy: [SortDescriptor(
                                \.timestamp,
                                 order: .reverse
                            )]
                        )
                    )) ?? []
            }
        }
    }

    func add(item: Item) {
        self.modelContext.insert(item)
        try? self.modelContext.save()
    }
}

public class SampleSwiftDataViewController: UIViewController {

    private var viewModel: SampleSwiftDataViewModel!

    @discardableResult
    public func set(viewModel: SampleSwiftDataViewModel) -> Self {
        self.viewModel = viewModel
        return self
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.declarative {
            UIScrollView {
                UIStackView(axis: .vertical)
                    .tracking {[weak self] in
                        self?.viewModel.items
                    } onChange: { stackView, items in
                        stackView.removeAllArrangedSubviews().addArrangedSubviews {
                            items.compactMap { item in
                                UILabel(item.timestamp.description)
                                    .padding(insets: .init(all: 8))
                            }
                        }
                    }
            }
        }.applyNavigationItem {
            $0.rightBarButtonItem = .init(
                customView: UIButton(
                    configuration: .plain().image(UIImage(systemName: "plus")),
                    primaryAction: .init(
                        handler: { [weak self] _ in
                            self?.viewModel.add(item: Item(timestamp: Date()))
                    })
                )
            )
        }.applyView {
            $0.backgroundColor = .secondarySystemBackground
        }
    }
}
