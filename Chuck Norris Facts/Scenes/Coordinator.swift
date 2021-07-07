import UIKit

class Coordinator {
    
    private(set) var navigationController = UINavigationController()
    
    private func setupNavigationController() {
        navigationController.navigationBar.isTranslucent = false
    }
    
    public func start() {
        setupNavigationController()
        goToSearch()
    }
    
    private func goToFacts() {
        let factsViewController = FactsViewController()
        factsViewController.onOpenSearch = { [weak self] in
            self?.goToSearch()
        }
        navigationController.pushViewController(factsViewController, animated: true)
    }
    
    private func goToSearch() {
        let searchViewController = SearchViewController()
//        navigationController.present(searchViewController, animated: true)
        navigationController.pushViewController(searchViewController, animated: true)
    }
    
}
