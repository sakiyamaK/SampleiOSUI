import UIKit
import DeclarativeUIKit
import ObservableUIKit
import SwiftData

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

@Model
public final class Item {
    var timestamp: Date

    public init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

@Observable
public final class ViewModel {
    private var modelContext: ModelContext?
    private(set) var items: [Item] = []

    deinit {
         NotificationCenter.default.removeObserver(self)
     }

    public init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        NotificationCenter.default.addObserver(forName: ModelContext.didSave, object: nil, queue: .main) { [weak self] _ in
            self?.items = (try? self?.modelContext?
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

    func add(item: Item) {
        self.modelContext?.insert(item)
        try? self.modelContext?.save()
    }
}

public class SampleViewController: UIViewController {

    private var viewModel: ViewModel!

    public func set(viewModel: ViewModel) -> Self {
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

//#Preview {
//    {
//        let schema = Schema([Item.self])
//        let container = try! ModelContainer(for: schema, configurations: ModelConfiguration())
//        print("container")
//        return UINavigationController(rootViewController:  SampleViewController(viewModel: ViewModel(modelContext: container.mainContext)))
////        do {
////        } catch let e {
////            print(e)
////            let nav = SampleViewController().applyView({
////                $0.backgroundColor = .systemRed
////            }).navigationController
////            return nav
////        }
//    }()
//}
