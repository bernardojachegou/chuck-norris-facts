import UIKit

class FactCard: UIView {
    
    private var fact: FactModel!
    
    private var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    init(fact: FactModel) {
        super.init(frame: .zero)
        self.fact = fact
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
        
        stack.removeAllArrangedSubviews()
        stack.fillParentView(padding: 8)
        stack.addArrangedSubview(titleLabel)
        setupTitle()
    }
    
    private func setupTitle() {
        titleLabel.text = fact.value
        // check font
    }
    
}
