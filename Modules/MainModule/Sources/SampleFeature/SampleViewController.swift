import UIKit
import DeclarativeUIKit
import Extensions
import Components

public class SampleViewController: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView().backgroundColor(.systemRed)
            .size(width: 20, height: 20)
            .padding(insets: .init(all: 60))
            .backgroundColor(.systemBlue)
            .apply({ view in
                view.translatesAutoresizingMaskIntoConstraints = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    let y = view.frame.origin.y
                    DLog(view.frame)
                    DLog(view.bounds)
                    view.frame = .init(x: view.frame.origin.x, y: y - 50, width: view.bounds.size.width, height: view.bounds.size.height)
                    DLog(view.frame)
                }
            })
        
        self.view.backgroundColor = .mainViewBackgroundColor
        self.view.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
        
    }
}
