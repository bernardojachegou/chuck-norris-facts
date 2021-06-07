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
        navigationController.pushViewController(factsViewController, animated: true)
    }
    
}
