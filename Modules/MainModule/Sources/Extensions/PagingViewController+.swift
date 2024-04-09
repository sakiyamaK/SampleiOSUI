import Parchment
import UIKit

public extension PagingViewController {
    @discardableResult
    func setup(
        borderOptions: PagingBorderOptions,
        borderColor: UIColor = UIColor.borderColor,
        indicatorOptions: PagingIndicatorOptions,
        delegate: PagingViewControllerDelegate,
        dataSource: PagingViewControllerDataSource? = nil
    ) -> Self {
        self.delegate = delegate
        if let dataSource {
            self.dataSource = dataSource
        }
        self.selectedScrollPosition = .preferCentered
        self.menuItemSize = .selfSizing(estimatedWidth: 55, height: 44)
        self.menuItemSpacing = -16
        self.menuItemLabelSpacing = 16
        self.borderColor = borderColor
        self.borderOptions = borderOptions
        self.font = .defaultFontMedium(size: 14)
        self.textColor = UIColor.subTextColor
        self.selectedFont = .defaultFontMedium(size: 14)
        self.selectedTextColor = UIColor.mainTextColor
        self.indicatorColor = UIColor.mainTextColor
        self.indicatorOptions = indicatorOptions
        return self
    }
}
