//
//  DeclarativeTableViewCell.swift
//  SampleiOSUI
//
//  Created by sakiyamaK on 2022/01/08.
//

import DeclarativeUIKit
import UIKit

final class DeclarativeTableViewCell: UITableViewCell {
    private var clinicImageView: UIImageView!
    private var clinicNameLabel: UILabel!
    private var clinicAddressLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.declarative(priorities: .init(top: .required, leading: .required, bottom: .defaultLow, trailing: .required)) {
            UIStackView.vertical {
                UIView.spacer().height(20)

                UIStackView.horizontal {
                    UIView.spacer().width(0)

                    UIStackView.horizontal {
                        UIImageView.imperative {
                            self.clinicImageView = ($0 as! UIImageView)
                        }.contentMode(.scaleAspectFill)
                        .backgroundColor(.gray)
                        .size(width: 66, height: 66)
                        .cornerRadius(10)

                        UIStackView.vertical {
                            UILabel.imperative {
                                self.clinicNameLabel = ($0 as! UILabel)
                            }.contentHuggingPriority(.required, for: .vertical)
                            .font(UIFont.systemFont(ofSize: 16))
                            .textColor(.black)
                            .numberOfLines(0)

                            UILabel.imperative {
                                self.clinicAddressLabel = ($0 as! UILabel)
                            }.contentHuggingPriority(.required, for: .vertical)
                            .font(UIFont.systemFont(ofSize: 11))
                            .textColor(.gray)
                            .numberOfLines(0)

                        }.spacing(2)

                        UIImageView(UIImage())
                            .size(width: 10, height: 10)
                            .contentMode(.scaleAspectFill)

                    }.alignment(.center)
                    .spacing(12)

                    UIView.spacer().width(0)

                }.spacing(20)

                UIView.spacer().height(20)
            }
        }
    }

    func configure() {
        clinicNameLabel.text = "オンラインクリニック"
        clinicAddressLabel.text = "〒000-0000東京都千代田区丸の内1-1-1"
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import SwiftUI

private struct View_Wrapper: UIViewRepresentable {
    typealias View = DeclarativeTableViewCell
    func makeUIView(context _: Context) -> View {
        return View(frame: .zero)
    }

    func updateUIView(_ cell: View, context _: Context) {
        cell.configure()
    }
}

struct GithubSearchCollectionViewCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            View_Wrapper().previewLayout(.fixed(width: 400, height: 200))
        }
    }
}
