import UIKit

class RDDetailViewController: UIViewController {
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 36, weight: UIFontWeightSemibold)
        return label
    }()
    
    required init(detailString: String) {
        super.init(nibName: nil, bundle: nil)
        self.detailLabel.text = detailString
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.detailLabel)
        NSLayoutConstraint.activate([self.detailLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     self.detailLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                     self.detailLabel.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor, multiplier: 1, constant: -16)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
