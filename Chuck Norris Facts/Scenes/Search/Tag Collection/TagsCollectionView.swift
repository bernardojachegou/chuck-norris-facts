import UIKit

protocol TagsCollectionViewDelegate: AnyObject {
    func didSelect(collectionView: TagsCollectionView, tag: String)
}

class TagsCollectionView: UIView {

    struct TagStyle {
        let foregroundColor: UIColor
        let backgroundColor: UIColor
    }

    public weak var delegate: TagsCollectionViewDelegate?
    private var collectionView: AutoHeightCollectionView!
    private var tags: [String] = [] {
        didSet {
            reloadCollectionView()
        }
    }
    public var tagStyle: TagStyle = TagStyle(foregroundColor: .white, backgroundColor: .primaryColor) {
        didSet {
            reloadCollectionView()
        }
    }

    init(delegate: TagsCollectionViewDelegate? = nil) {
        super.init(frame: .zero)
        self.delegate = delegate
        initializeCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeCollectionView() {
        let layout = TagCellLayout(alignment: .left, delegate: self)
        collectionView = AutoHeightCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)

        addSubview(collectionView)
        collectionView.fillParentView()

        reloadCollectionView()
    }

    private func reloadCollectionView() {
        collectionView.reloadData()
    }

    public func setTags(_ tags: [String]) {
        self.tags = tags
    }
}

extension TagsCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath)

        if let cell = cell as? TagCell {
            let tag = tags[indexPath.row]
            cell.title = tag
            cell.setStyle(foregroundColor: tagStyle.foregroundColor, backgroundColor: tagStyle.backgroundColor)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = tags[indexPath.row]
        delegate?.didSelect(collectionView: self, tag: tag)
    }
}

extension TagsCollectionView: TagCellLayoutDelegate {
    func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index: Int) -> CGSize {
        let tag = tags[index]
        let textLength = tag.lengthOfBytes(using: .utf8)
        let multiplier = textLength > 10 ? 10 : textLength
        let cellWidth = multiplier * 12 + 8
        return CGSize(width: cellWidth, height: 30)
    }
}
