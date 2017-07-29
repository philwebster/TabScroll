import UIKit

class RDTopTabBarController: UIViewController {
    
    let tabControl: RDTabControl
    let scrollView = RDTabScrollView()
    let controlStack = UIStackView()
    
    init(theme: RDTabControlTheme = .default) {
        self.tabControl = RDTabControl(theme: theme)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.scrollView.delegate = self
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.scrollView)

        self.tabControl.delegate = self
        self.tabControl.scrollView = self.scrollView
        
        self.controlStack.axis = .vertical
        self.controlStack.addArrangedSubview(self.tabControl)
        self.controlStack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.controlStack)
        
        NSLayoutConstraint.activate([self.controlStack.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                                     self.controlStack.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                                     self.controlStack.topAnchor.constraint(equalTo: self.view.topAnchor),
                                     self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                                     self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                                     self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                     self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.childViewControllers.forEach {
            if $0.automaticallyAdjustsScrollViewInsets {
                let insets = UIEdgeInsets(top: self.tabControl.bounds.height, left: 0, bottom: 0, right: 0)
                ($0.view as? UIScrollView)?.scrollIndicatorInsets = insets
                ($0.view as? UIScrollView)?.contentInset = insets
            }
        }
    }
    
    func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        self.childViewControllers.forEach { $0.willMove(toParentViewController: nil) }
        self.scrollView.pagedViews = []
        self.childViewControllers.forEach { $0.removeFromParentViewController() }
        
        viewControllers?.forEach { self.addChildViewController($0) }
        self.scrollView.pagedViews = viewControllers?.map { $0.view } ?? []
        viewControllers?.forEach { $0.didMove(toParentViewController: self) }
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        let contentOffset = -self.tabControl.bounds.height
        viewControllers?.forEach { ($0.view as? UIScrollView)?.contentOffset.y = contentOffset }
        
        self.tabControl.setTitles(titles: self.childViewControllers.map { $0.title ?? "No Title" })
    }
}

extension RDTopTabBarController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let scrollView = scrollView as? RDTabScrollView,
            scrollView.contentSize.width > 0 else {
            return
        }
        
        self.tabControl.updateSelectionIndicator()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollView.updateCurrentPage()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollView.updateCurrentPage()
    }
}

extension RDTopTabBarController: RDTabControlDelegate {
    
    func tabControl(_ tabControl: RDTabControl?, didSelectButtonAt index: Int) {
        guard index < self.childViewControllers.count else {
            return
        }
        
        let viewController = self.childViewControllers[index]
        self.scrollView.scrollRectToVisible(viewController.view.frame, animated: true)
    }
}
