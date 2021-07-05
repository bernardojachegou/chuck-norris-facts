import UIKit

class SearchViewController: BaseViewController {
    
    override func didSetup() {
        super.didSetup()
        setupNavBar()
        setupBindings()
    }
    
    override func getContentView() -> UIView {
        return renderSearchView()
    }
    
    private func setupNavBar() {
        setTitle("Search facts")
    }
    
    private func renderSearchView() -> UIView {
        return UIView()
    }
    
    private func setupBindings() {
        //
    }
    
}
