//
//  SampleCollectionViewController.swift
//
//
//  Created by sakiyamaK on 2024/06/28.
//

import DeclarativeUIKit
import UIKit
import Extensions
import SwiftyAttributes

final class TicketDetail2HeaderContentView: UIView, UIContentView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    struct Delegate {
    }

    struct Configuration: UIContentConfiguration {
        // let item: TicketDetail2HeaderEntity
        let delegate: Delegate

        func makeContentView() -> UIView & UIContentView {
            TicketDetail2HeaderContentView(configuration: self)
        }
    }

    var configuration: UIContentConfiguration {
        didSet {
            configure()
        }
    }

    var fixedConfiguration: Configuration {
        configuration as! Configuration
    }

    private let mainNameLabel = UILabel()
    private let subNameLabel = UILabel()
    private let dateLabel = UILabel()
    private let userNameLabel = UILabel()
    private let receiptButton = UIButton()
    private let eventDetailButton = UIButton()
//    private let kensyuStackView = UIStackView.vertical {
//    }

    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: .zero)

        let delegate = fixedConfiguration.delegate

        self.resetDeclarativeUIKitLayout()
            .declarative {
                UIView.path { rect in
                    UIBezierPath().apply { path in
                        path.move(to: .init(x: 0, y: rect.size.height))
                        path
                            .addLine(
                                to: .init(
                                    x: rect.size.width,
                                    y: rect.size.height
                                )
                            )

                        let dashes:[CGFloat] = [10]
                        path.setLineDash(dashes, count: dashes.count, phase: 0)

                    }.stroke(.black, lineWidth: 1)
                }
                .cornerRadius(16)
                .clipsToBounds(true)
                .backgroundColor(.white)
                .zStack {
                    UIStackView.vertical {

                        self.mainNameLabel
                            .text("【限定公開 | ご招待者様】Art Fair Beppu 2024")
                            .font(
                                UIFont.preferredFont(
                                    forTextStyle: .title2
                                ).withSymbolicTraits(
                                    .traitBold
                                )
                            )
                            .textColor(.Text.mainWhite)
                            .numberOfLines(0)
                            .contentPriorities(.init(vertical: .required))
                            .padding(insets: .init(vertical: 16, horizontal: 24))
                            .backgroundColor(.black)
                            .customSpacing(24)

                        UIStackView.vertical(spacing: 32) {
                            UIStackView.vertical(spacing: 16) {
                                self.subNameLabel
                                    .text("【ご招待】Art Fair Beppu 2024")
                                    .font(
                                        UIFont
                                            .preferredFont(
                                                forTextStyle: .title3
                                            )
                                            .withSymbolicTraits(.traitBold)
                                    )
                                    .textColor(.Text.main)
                                    .numberOfLines(0)
                                    .contentPriorities(.init(vertical: .required))

                                self.dateLabel
                                    .text("2024.08.13(火)")
                                    .font(
                                        UIFont
                                            .preferredFont(forTextStyle: .body)
                                            .withSymbolicTraits(.traitBold)
                                    )
                                    .textColor(.Text.main)
                                    .numberOfLines(0)
                                    .contentPriorities(.init(vertical: .required))

                                self.createKensyu(typeName: "大人", infoStr: "¥1,000（税込） x1")
                                self.createKensyu(typeName: "大人", infoStr: "¥1,000（税込） x1")

                                self.userNameLabel
                                    .text("テストタロウ")
                                    .font(
                                        UIFont.preferredFont(forTextStyle: .callout)
                                    )
                                    .textColor(.black)
                                    .numberOfLines(0)
                                    .contentPriorities(.init(vertical: .required))

                                self.receiptButton
                                    .configuration(
                                        .plain()
                                        .title("領収書を表示")
                                        .baseForegroundColor(.green)
                                        .contentInsets(
                                            UIButton
                                                .Configuration
                                                .plain()
                                                .contentInsets
                                                .edgeInsets
                                                .select
                                                .top
                                                .bottom
                                                .right
                                                .fixed
                                                .directionalEdgeInsets
                                        )
                                    )
                                    .left()
                            }

                            self.eventDetailButton
                                .configuration(
                                    .storkeButtonConfiguration(
                                        title: "イベント詳細を見る",
                                        buttonSize: .large
                                    )
                                )

                            UIView.spacer()
                        }
                        .padding(insets: .init(horizontal: 24))
                    }
                }
            }
    }

    private func createKensyu(typeName: String, infoStr: String) -> UIView {
        UIStackView.vertical {
            UILabel(typeName)
                .font(
                    UIFont.preferredFont(forTextStyle: .callout)
                )
                .textColor(.Text.main)
                .numberOfLines(1)
                .contentPriorities(.init(vertical: .required))

            UILabel(infoStr)
                .font(
                    UIFont.preferredFont(forTextStyle: .callout)
                )
                .textColor(.Text.main)
                .numberOfLines(1)
                .contentPriorities(.init(vertical: .required))
        }
    }

    private func configure() {
    }
}

final class TicketDetail2EntranceInstructionContentView: UIView, UIContentView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    struct Delegate {
    }

    struct Configuration: UIContentConfiguration {
        // let item: TicketDetail2EntranceInstructionEntity
        let delegate: Delegate

        func makeContentView() -> UIView & UIContentView {
            TicketDetail2EntranceInstructionContentView(configuration: self)
        }
    }

    var configuration: UIContentConfiguration {
        didSet {
            configure()
        }
    }

    var fixedConfiguration: Configuration {
        configuration as! Configuration
    }

    private let mainNameLabel = UILabel()
    private let subNameLabel = UILabel()
    private let dateLabel = UILabel()
    private let userNameLabel = UILabel()
    private let receiptButton = UIButton()
    private let eventDetailButton = UIButton()

    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: .zero)

        let delegate = fixedConfiguration.delegate

        self.resetDeclarativeUIKitLayout()
            .declarative {
                UIView.path { rect in
                    UIBezierPath().apply { path in
                        path.move(to: .init(x: 0, y: rect.size.height))
                        path
                            .addLine(
                                to: .init(
                                    x: rect.size.width,
                                    y: rect.size.height
                                )
                            )

                        let dashes:[CGFloat] = [10]
                        path.setLineDash(dashes, count: dashes.count, phase: 0)

                    }.stroke(.black, lineWidth: 1)
                }
                .cornerRadius(16)
                .clipsToBounds(true)
                .backgroundColor(.white)
                .zStack {
                    UIStackView.vertical(spacing: 32) {
                        UILabel("入場方法")
                            .font(
                                UIFont
                                    .preferredFont(
                                        forTextStyle: .title2
                                    )
                                    .withSymbolicTraits(.traitBold)
                            )
                            .textColor(.Text.main)
                            .numberOfLines(0)
                            .contentPriorities(.init(vertical: .required))

                        self.createGroupEntranceSection()
                        self.createIndividualEntranceSection()
                    }
                    .padding(insets: .init(vertical: 32, horizontal: 16))
                }
            }
    }

    private func createGroupEntranceSection() -> UIView {
        UIStackView.vertical(spacing: 16) {
            UILabel("全員まとめて入場する")
                .font(
                    UIFont
                        .preferredFont(
                            forTextStyle: .title3
                        )
                        .withSymbolicTraits(.traitBold)
                )
                .textColor(.Text.main)
                .numberOfLines(0)
                .contentPriorities(.init(vertical: .required))

            UILabel("全員まとめて利用する場合は、以下から操作してください。")
                .font(
                    UIFont
                        .preferredFont(
                            forTextStyle: .callout
                        )
                )
                .textColor(.Text.main)
                .numberOfLines(0)
                .contentPriorities(.init(vertical: .required))

            self.createButtons()
        }
    }

    private func createIndividualEntranceSection() -> UIView {
        UIStackView.vertical(spacing: 16) {
            UILabel("1人ずつ入場する")
                .font(
                    UIFont
                        .preferredFont(
                            forTextStyle: .title3
                        )
                        .withSymbolicTraits(.traitBold)
                )
                .textColor(.Text.main)
                .numberOfLines(0)
                .contentPriorities(.init(vertical: .required))

            UILabel("1人ずつ入場したい場合は、利用したいチケットを選択して、QRコードを表示してください。\n\n 同行者にチケットを共有する場合は、共有したいチケットの「チケットを共有」ボタンからチケットリンクをコピーして送信してください。")
                .font(
                    UIFont
                        .preferredFont(
                            forTextStyle: .callout
                        )
                )
                .textColor(.Text.main)
                .numberOfLines(0)
                .contentPriorities(.init(vertical: .required))

            self.createButtons()
            self.createButtons()
            self.createButtons()
            self.createButtons()
        }
    }

    private func createButtons() -> UIView {
        UIStackView.vertical {
            UILabel("3枚利用可能(全5枚)")
                .font(
                    UIFont
                        .preferredFont(
                            forTextStyle: .callout
                        )
                        .withSymbolicTraits(.traitBold)
                )
                .textColor(.Text.main)
                .numberOfLines(0)
                .contentPriorities(.init(vertical: .required))
                .customSpacing(20)

            UILabel("利用可能なすべてのチケット")
                .font(
                    UIFont
                        .preferredFont(
                            forTextStyle: .title2
                        )
                        .withSymbolicTraits(.traitBold)
                )
                .textColor(.Text.main)
                .textAlignment(.center)
                .numberOfLines(0)
                .contentPriorities(.init(vertical: .required))
                .customSpacing(16)

            UIButton(
                configuration:
                        .filled()
                        .title("QRコードを表示")
                        .image(UIImage(systemName: "qrcode.viewfinder"))
                        .imagePadding(8)
                        .cornerStyle(.capsule)
                        .baseBackgroundColor(.ViewBackground.mainBlack)
                        .baseForegroundColor(.Text.mainWhite)
                        .buttonSize(.large)
            )
            .customSpacing(12)

            UIButton(
                configuration:
                        .filled()
                        .title("チケットを共有")
                        .image(UIImage(systemName: "qrcode.viewfinder"))
                        .imagePadding(8)
                        .cornerStyle(.capsule)
                        .baseBackgroundColor(.ViewBackground.main)
                        .baseForegroundColor(.Text.main)
                        .buttonSize(.large)
                        .background(
                            .clear()
                            .strokeColor(.ViewBackground.border)
                            .strokeWidth(1.0)
                        )
            )
            .customSpacing(20)

            UILabel("再入場可能期限：2023.01.01")
                .font(
                    UIFont
                        .preferredFont(
                            forTextStyle: .caption1
                        )
                )
                .textColor(.Text.main)
                .numberOfLines(0)
                .contentPriorities(.init(vertical: .required))

            UIButton(
                configuration:
                        .plain()
                        .attributedTitle("チケット管理番号：278-203-023".withFont(UIFont
                            .preferredFont(
                                forTextStyle: .caption1
                            )
                        ))
                        .baseForegroundColor(.Text.main)
                        .image(UIImage(systemName: "qrcode.viewfinder"))
                        .imagePlacement(.trailing)
                        .imagePadding(8)
                        .buttonSize(.small)
                        .contentInsets(
                            UIButton.Configuration
                                .plain().contentInsets
                                .edgeInsets.select.top.bottom.right.fixed.directionalEdgeInsets
                        )
            )
            .left()
        }
        .padding(insets: .init(vertical: 24, horizontal: 16))
        .backgroundColor(.ViewBackground.mainGray)
        .cornerRadius(16)

    }

    private func configure() {
    }
}

final class TicketDetail2AbountCancelContentView: UIView, UIContentView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    struct Delegate {
    }

    struct Configuration: UIContentConfiguration {
        // let item: TicketDetail2AbountCancelEntity
        let delegate: Delegate

        func makeContentView() -> UIView & UIContentView {
            TicketDetail2AbountCancelContentView(configuration: self)
        }
    }

    var configuration: UIContentConfiguration {
        didSet {
            configure()
        }
    }

    var fixedConfiguration: Configuration {
        configuration as! Configuration
    }

    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: .zero)

        let delegate = fixedConfiguration.delegate

        self.resetDeclarativeUIKitLayout()
            .declarative {
                UIView.path { rect in
                    UIBezierPath().apply { path in
                        path.move(to: .init(x: 0, y: rect.size.height))
                        path
                            .addLine(
                                to: .init(
                                    x: rect.size.width,
                                    y: rect.size.height
                                )
                            )

                        let dashes:[CGFloat] = [10]
                        path.setLineDash(dashes, count: dashes.count, phase: 0)

                    }.stroke(.black, lineWidth: 1)
                }
                .cornerRadius(16)
                .clipsToBounds(true)
                .backgroundColor(.white)
                .zStack {
                    UIStackView.vertical(spacing: 32) {
                        UILabel("キャンセルに関して")
                            .font(
                                UIFont
                                    .preferredFont(
                                        forTextStyle: .title2
                                    )
                                    .withSymbolicTraits(.traitBold)
                            )
                            .textColor(.Text.main)
                            .numberOfLines(0)
                            .contentPriorities(.init(vertical: .required))

                        UIStackView.vertical(spacing: 16) {
                            UILabel("以下よりチケットのキャンセルが可能です。")
                                .font(
                                    UIFont
                                        .preferredFont(
                                            forTextStyle: .callout
                                        )
                                        .withSymbolicTraits(.traitBold)
                                )
                                .textColor(.Text.main)
                                .numberOfLines(0)
                                .contentPriorities(.init(vertical: .required))

                            UIButton(
                                configuration:
                                        .filled()
                                        .title("チケットをキャンセルする")
                                        .image(UIImage(systemName: "qrcode.viewfinder"))
                                        .imagePadding(8)
                                        .cornerStyle(.capsule)
                                        .baseBackgroundColor(.ViewBackground.main)
                                        .baseForegroundColor(.Text.main)
                                        .buttonSize(.large)
                                        .background(
                                            .clear()
                                            .strokeColor(.ViewBackground.border)
                                            .strokeWidth(1.0)
                                        )
                            )
                            .customSpacing(8)

                            UILabel("キャンセル可能期間: 2025.01.01.12:00:00 まで")
                                .font(
                                    UIFont
                                        .preferredFont(
                                            forTextStyle: .caption2
                                        )
                                )
                                .textColor(.Text.main)
                                .textAlignment(.center)
                                .numberOfLines(0)
                                .contentPriorities(.init(vertical: .required))

                        }

                        UIStackView.vertical(spacing: 16) {
                            UILabel("キャンセルポリシー")
                                .font(
                                    UIFont
                                        .preferredFont(
                                            forTextStyle: .callout
                                        )
                                        .withSymbolicTraits(.traitBold)
                                )
                                .textColor(.Text.main)
                                .numberOfLines(0)
                                .contentPriorities(.init(vertical: .required))

                            UILabel("未使用であっても、購入後の払い戻しはできませんのでご注意ください。")
                                .font(
                                    UIFont
                                        .preferredFont(
                                            forTextStyle: .callout
                                        )
                                )
                                .textColor(.Text.main)
                                .numberOfLines(0)
                                .contentPriorities(.init(vertical: .required))

                            UILabel("Please be aware that there are no refunds following purchase, even if the ticket has not been used.")
                                .font(
                                    UIFont
                                        .preferredFont(
                                            forTextStyle: .callout
                                        )
                                )
                                .textColor(.Text.main)
                                .numberOfLines(0)
                                .contentPriorities(.init(vertical: .required))

                        }
                    }
                    .padding(insets: .init(vertical: 32, horizontal: 16))
                }
            }
    }

    private func configure() {
    }
}

public class SampleCollectionViewController: UIViewController {

    deinit { DLog() }

    private var items: [Int] = (0...4).compactMap({ v in
        v
    })

    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.applyView({
            $0.backgroundColor(.systemBackground)
        }).applyNavigationItem({
            $0.title = "Sample"
        }).declarative {
            UICollectionView {
                UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                    var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
                    let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
                    return section
                }
            }
            .apply({ collectionView in
                let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Void> { cell, indexPath, item in
                    cell.contentConfiguration = TicketDetail2HeaderContentView.Configuration(
                        //                            item: item,
                        delegate: .init(
                        )
                    )
                }

                self.dataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
                    switch indexPath.section {
                    default:
                        collectionView.dequeueConfiguredReusableCell(
                            using: cellRegistration,
                            for: indexPath,
                            item: ()
                        )
                    }
                }

                var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
                snapshot.appendSections([0])
                snapshot.appendItems(
                    self.items.compactMap({ $0.description }),
                    toSection: 0
                )
                self.dataSource.apply(snapshot)
            })
        }
    }
}

//#Preview {
//    SampleCollectionViewController()
//}

#Preview {
    UIViewController().applyView({ $0.backgroundColor(.gray) }).declarative {
        UIScrollView.vertical {
            UIStackView.vertical {
                TicketDetail2AbountCancelContentView
                    .Configuration(delegate: .init())
                    .makeContentView()
                TicketDetail2EntranceInstructionContentView
                    .Configuration(delegate: .init())
                    .makeContentView()
                TicketDetail2HeaderContentView
                    .Configuration(delegate: .init())
                    .makeContentView()
            }
        }
    }
}
