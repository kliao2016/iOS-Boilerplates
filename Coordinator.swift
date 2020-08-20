import UIKit

class Coordinator: NSObject {

    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []

    func start() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }

    func finish() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }

    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(of: coordinator) {
            childCoordinators.remove(at: index)
        } else {
            print("Couldn't remove coordinator: \(coordinator). It's not a child coordinator.")
        }
    }

    func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        childCoordinators = childCoordinators.filter { $0 is T  == false }
    }

    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }

}

class MainTabCoordinator: Coordinator {
    
    let window: UIWindow?
    
    lazy var rootTabBarController: UITabBarController = {
        return tabBarController
    }()
    
    let tabBarController: UITabBarController
    
    let drillsCoordinator: DrillsCoordinator
    let dashboardCoordinator: DashboardCoordinator
    let analysisCoordinator: AnalysisCoordinator

    // MARK: - Coordinator
    init(window: UIWindow?) {
        self.window = window
        
        tabBarController = UITabBarController()
        
        drillsCoordinator = DrillsCoordinator()
        dashboardCoordinator = DashboardCoordinator()
        analysisCoordinator = AnalysisCoordinator()
        
        let drillsNavController = drillsCoordinator.rootNavController
        drillsNavController.tabBarItem = UITabBarItem(title: "Drills", image: UIImage(systemName: "square.and.arrow.up"), selectedImage: UIImage(systemName: "square.and.arrow.up.fill"))
        
        let dashboardNavController = dashboardCoordinator.rootNavController
        dashboardNavController.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "square.and.arrow.up"), selectedImage: UIImage(systemName: "square.and.arrow.up.fill"))
        
        let analysisNavController = analysisCoordinator.rootNavController
        analysisNavController.tabBarItem = UITabBarItem(title: "Analysis", image: UIImage(systemName: "square.and.arrow.up"), selectedImage: UIImage(systemName: "square.and.arrow.up.fill"))
        
        super.init()
        childCoordinators.append(drillsCoordinator)
        childCoordinators.append(dashboardCoordinator)
        childCoordinators.append(analysisCoordinator)
        
        tabBarController.viewControllers = [drillsNavController, dashboardNavController, analysisNavController]
        tabBarController.tabBar.isTranslucent = false
        tabBarController.delegate = self
    }

    override func start() {
        guard let window = window else {
            return
        }

        window.rootViewController = rootTabBarController
        window.makeKeyAndVisible()
    }
}
