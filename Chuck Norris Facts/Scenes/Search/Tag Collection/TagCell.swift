import UIKit

class TagCell: UICollectionViewCell {
    
    static var identifier: String = {
        return String(describing: TagCell.self)
    }()
    
    public var title: String! {
        didSet {
            updateTitle()
        }
    }
    
    public func setStyle(foregroundColor: UIColor, backgroundColor: UIColor) {
        contentView.backgroundColor = backgroundColor
        titleLabel.textColor = foregroundColor
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStyle(foregroundColor: .white, backgroundColor: .primaryColor)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateTitle() {
        titleLabel.text = title
    }
    
    private func setupCell() {
        contentView.addSubview(titleLabel)
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
        
        contentView.fillParentView(padding: 4)
        titleLabel.fillParentView(padding: 4)
    }
    
}
