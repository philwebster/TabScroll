import UIKit

protocol RDTabControlDelegate: class {
    func tabControl(_ tabControl: RDTabControl?, didSelectButtonAt index: Int)
}

struct RDTabControlTheme {
    let backgroundColor: UIColor
    let normalColor: UIColor
    let highlightedColor: UIColor
    let selectedColor: UIColor
    let selectionIndicatorColor: UIColor
    let selectionIndicatorHeight: CGFloat
    let showsDivider: Bool
    let dividerColor: UIColor?
    let fontAttributes: [String: NSObject]
    
    static let `default` = RDTabControlTheme(backgroundColor: UIColor.white,
                                             normalColor: UIColor.gray,
                                             highlightedColor: UIColor.lightGray,
                                             selectedColor: UIColor.darkGray,
                                             selectionIndicatorColor: UIColor.darkGray,
                                             selectionIndicatorHeight: 1,
                                             showsDivider: true,
                                             dividerColor: UIColor.lightGray,
                                             fontAttributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13, weight: UIFontWeightSemibold)])
}

class RDTabControl: UIView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 48)
    }
    
    private(set) var theme: RDTabControlTheme
    private(set) var buttons = [UIButton]()
    private(set) var divider = UIView()
    private var selectionIndicator = UIView()
    weak var scrollView: RDTabScrollView?
    weak var delegate: RDTabControlDelegate?
    
    private var dividerHeight: CGFloat {
        return self.theme.showsDivider ? 0.5 : 0
    }
    
    init(theme: RDTabControlTheme = .default) {
        self.theme = theme
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 48))
        
        self.backgroundColor = theme.backgroundColor
        self.selectionIndicator.backgroundColor = theme.selectionIndicatorColor
        self.divider.backgroundColor = theme.dividerColor
        self.divider.isHidden = !theme.showsDivider
    
        self.addSubview(self.divider)
        self.addSubview(self.selectionIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitles(titles: [String]) {
        self.buttons.forEach { $0.removeFromSuperview() }
        
        self.buttons = titles.map { title in
            let button = UIButton(type: .custom)
            button.addTarget(self, action: #selector(self.handleButtonPress(sender:)), for: .touchUpInside)
            self.styleButton(button, title: title)
            self.addSubview(button)
            return button
        }
        
        self.updateSelectionIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonWidth = self.bounds.width / CGFloat(self.buttons.count)
        for (index, button) in self.buttons.enumerated() {
            button.frame = CGRect(x: CGFloat(index) * buttonWidth, y: 0, width: buttonWidth, height: self.intrinsicContentSize.height)
        }
        
        self.updateSelectionIndicator()
        
        self.divider.frame = CGRect(x: 0, y: self.bounds.height - self.dividerHeight, width: self.bounds.width, height: self.dividerHeight)
    }
    
    fileprivate func styleButton(_ button: UIButton, title: String) {
        button.setAttributedTitle(NSAttributedString(string: title, attributes: self.attributesWithColor(self.theme.normalColor)), for: .normal)
        button.setAttributedTitle(NSAttributedString(string: title, attributes: self.attributesWithColor(self.theme.highlightedColor)), for: .highlighted)
        button.setAttributedTitle(NSAttributedString(string: title, attributes: self.attributesWithColor(self.theme.selectedColor)), for: .selected)
    }
    
    fileprivate func attributesWithColor(_ color: UIColor) -> [String: NSObject] {
        var attributes = self.theme.fontAttributes
        attributes[NSForegroundColorAttributeName] = color
        return attributes
    }

    func handleButtonPress(sender: UIButton) {
        guard let index = self.buttons.index(of: sender) else {
            return
        }
        self.updateSelectionIndicator()
        self.delegate?.tabControl(self, didSelectButtonAt: index)
    }
    
    private func focusOnButtonAtIndex(_ index: Int, animated: Bool) {
        guard index < self.buttons.count else {
            return
        }
        
        let buttonToSelect = self.buttons[index]
        if buttonToSelect.isSelected {
            return
        }

        let duration: TimeInterval = animated ? 0.25 : 0
        UIView.animate(withDuration: duration) {
            self.buttons.forEach { $0.isSelected = false }
            buttonToSelect.isSelected = true
        }
    }
    
    func updateSelectionIndicator() {
        guard let scrollView = self.scrollView,
            scrollView.contentSize.width > 0,
            self.buttons.count > 0 else {
            return
        }
        
        let offset = scrollView.bounds.width * (scrollView.contentOffset.x / scrollView.contentSize.width)
        let y = self.bounds.maxY - self.theme.selectionIndicatorHeight
        let height = self.theme.selectionIndicatorHeight
        let width = self.bounds.width / CGFloat(self.buttons.count)
        self.selectionIndicator.frame = CGRect(x: offset, y: y, width: width, height: height)
        
        self.focusOnButtonAtIndex(self.scrollView?.mostVisibleIndex ?? 0, animated: true)
    }
}
