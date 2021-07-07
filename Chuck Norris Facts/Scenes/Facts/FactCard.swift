import UIKit

class FactCard: UIView {
    private let factSizeForSmallerFont = 80
    
    private var onShareButtonTap: ((String) -> ())?
    
    private var fact: FactModel!
    
    private var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    private var actionRowStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.numberOfLines = 0
        return label
    }()
    
    private var categoriesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
    
    private var iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "chuckNorris"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 54).isActive = true
        return imageView
    }()
    
    private var shareButton: UIButton = {
        let button = UIButton()
        let icon = UIImage(systemName: "square.and.arrow.up")?.withTintColor(.primaryColor)
        button.setImage(icon, for: .normal)
        button.tintColor = .primaryColor
        button.setTitleColor(.primaryColor, for: .normal)
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        return button
    }()
    
    init(fact: FactModel, onSharing: ((String) -> ())? = nil) {
        super.init(frame: .zero)
        self.fact = fact
        self.onShareButtonTap = onSharing
        setupCard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCard() {
        
        addSubview(stack)
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        layer.cornerRadius = 8
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.2
        
        let actionHolder = UIView()
        actionHolder.backgroundColor = UIColor(white: 0, alpha: 0.1)
        actionHolder.layer.cornerRadius = 4
        actionHolder.clipsToBounds = true
        let holder = UIView()
        holder.translatesAutoresizingMaskIntoConstraints = false
        holder.widthAnchor.constraint(equalToConstant: 32).isActive = true
        actionRowStack.addArrangedSubview(holder)
        actionRowStack.addArrangedSubview(categoriesLabel)
        actionRowStack.addArrangedSubview(shareButton)
        actionHolder.addSubview(actionRowStack)
        actionRowStack.fillParentView(padding: 4)
        
        stack.removeAllArrangedSubviews()
        stack.fillParentView(padding: 8)
        stack.addArrangedSubview(actionHolder)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(iconImageView)
        
        setupTitle()
        
        let categories = fact.categories.isEmpty ? ["uncategorized"] : fact.categories
        categoriesLabel.text = categories.map { $0.uppercased() }.joined(separator: ", ")
    }
    
    private func getCategoryLabelPill(_ category: String) -> UIView {
        let pill = UIView()
        let label = UILabel()
        label.text = category
        label.textColor = .white
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        pill.backgroundColor = .primaryColor
        pill.layer.cornerRadius = 4
        pill.clipsToBounds = true
        pill.addSubview(label)
        label.fillParentView(padding: 4)
        return pill
    }
    
    private func getFontSizeForContent() -> CGFloat {
        return fact.value.lengthOfBytes(using: .utf8) > factSizeForSmallerFont ? 12 : 16
    }
    
    private func setupTitle() {
        titleLabel.text = fact.value
        titleLabel.font = .systemFont(ofSize: getFontSizeForContent())
    }
    
    @objc private func shareButtonTapped() {
        onShareButtonTap?(fact.url)
    }
    
}
