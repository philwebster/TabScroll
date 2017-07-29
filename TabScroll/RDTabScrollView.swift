import UIKit

class RDTabScrollView: UIScrollView {

    var currentPage: Int = 0
    private var widthChanged = false
    var allowedBounceEdges = UIRectEdge.all
    
    override var bounds: CGRect {
        didSet {
            self.widthChanged = oldValue.width != self.bounds.width
        }
    }
    
    var pagedViews = [UIView]() {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            self.pagedViews.forEach { self.addSubview($0) }
        }
    }

    var mostVisibleIndex: Int? {
        let origins = self.pagedViews.map { $0.frame.origin.x }
        let diffs = origins.map { abs(self.contentOffset.x - $0) }
        guard let minimum = diffs.min() else {
            return nil
        }
        return diffs.index(of: minimum)
    }
    
    init() {
        super.init(frame: .zero)
        
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        for (index, view) in self.pagedViews.enumerated() {
            view.frame = CGRect(origin: CGPoint(x: CGFloat(index) * self.bounds.width, y: 0), size: self.bounds.size)
        }
        
        self.contentSize = CGSize(width: self.bounds.width * CGFloat(self.pagedViews.count), height: self.bounds.height)
        
        if self.widthChanged {
            let newContentOffset = CGFloat(self.currentPage) * self.bounds.width
            self.setContentOffset(CGPoint(x: newContentOffset, y: self.contentOffset.y), animated: false)
        }
    }
    
    func updateCurrentPage() {
        self.currentPage = self.mostVisibleIndex ?? 0
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.panGestureRecognizer {
            if !self.allowedBounceEdges.contains(.left) && self.panGestureRecognizer.velocity(in: self).x > 0 && self.contentOffset.x <= 0 {
                return false
            }
            if !self.allowedBounceEdges.contains(.right) && self.panGestureRecognizer.velocity(in: self).x < 0 && self.contentOffset.x >= self.contentSize.width - self.bounds.width {
                return false
            }
        }
        
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}
