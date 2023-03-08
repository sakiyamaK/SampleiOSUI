import DeclarativeUIKit
import UIKit
import Extensions

public final class AnimatedFloatingActionButton: UIView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private weak var imageView: UIImageView!
    private weak var label: UILabel!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        //        NotificationCenter.default.addObserver(self,
        //                                               selector: #selector(updateLayout),
        //                                               name: Notification.Name.injection, object: nil)
        updateLayout()
    }

    @objc private func updateLayout() {
        declarative {
            UIStackView.horizontal {
                UIImageView(UIImage(systemName: "house")?.withTintColor(.black, renderingMode: .alwaysOriginal))
                    .contentMode(.scaleAspectFit)
                    .assign(to: &imageView)
                UILabel(assign: &label)
            }
            .spacing(4)
            .padding(insets: .init(horizontal: 10))
        }
    }

    func configure(text: String) -> Self {
        self.label.text = text
        return self
    }

    @discardableResult
    func configure(select: Bool) -> Self {
        if select {
            self.backgroundColor = .black
            self.imageView.image = UIImage(systemName: "house")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            self.label.textColor = .white
            self.label.isHidden = false
        } else {
            self.backgroundColor = .white
            self.imageView.image = UIImage(systemName: "house")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            self.label.textColor = .black
            self.label.isHidden = true
        }
        return self
    }
}

public final class AnimatedFloatingActionButtons: UIView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var buttons: [AnimatedFloatingActionButton] = []

    public override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateLayout),
                                               name: Notification.Name.injection, object: nil)
        updateLayout()
    }

    private func tap(number: Int) {
        print("---tap--")
        print(number)
        let animation = UIViewPropertyAnimator(duration: 0.1, curve: .linear) {
            self.buttons.enumerated().forEach({ index, button in
                button.configure(select: number == index)
            })
        }
        animation.addCompletion { _ in
            self.buttons.enumerated().forEach({ index, button in
                button.configure(select: number == index)
            })
        }
        animation.startAnimation()
    }

    @objc private func updateLayout() {

        declarative {
            UIView()
        }
    }
}
