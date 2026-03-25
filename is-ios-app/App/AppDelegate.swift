import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        guard let windowScene = application.connectedScenes.first as? UIWindowScene else {
            return true
        }

        let viewController = AuthViewController()
        let router = AuthRouterImpl()
        let loginUseCase = LocalLoginUseCase()
        let presenter = AuthPresenterImpl(
            view: viewController,
            router: router,
            loginUseCase: loginUseCase
        )

        viewController.presenter = presenter
        router.viewController = viewController

        let navigationController = UINavigationController(rootViewController: viewController)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
