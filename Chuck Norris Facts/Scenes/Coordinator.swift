import UIKit

class Coordinator {
    
    private(set) var navigationController = UINavigationController()
    
    private func setupNavigationController() {
        navigationController.navigationBar.isTranslucent = false
    }
    
    public func start() {
        setupNavigationController()
        goToFacts()
    }
    
    private func goToFacts() {
        let factsViewController = FactsViewController()
        factsViewController.onOpenSearch = { [weak self] in
            self?.goToSearch(withDelegate: factsViewController)
        }
        navigationController.pushViewController(factsViewController, animated: true)
    }
    
    private func goToSearch(withDelegate delegate: SearchViewControllerDelegate? = nil) {
        let searchViewController = SearchViewController()
        searchViewController.delegate = delegate
        navigationController.present(searchViewController, animated: true)
    }
    
}
