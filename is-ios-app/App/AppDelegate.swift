import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let productsURL = URL(string: "https://alfaitmo.ru/server/echo/409515%2Fbank%2Fproducts")!
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        guard let windowScene = application.connectedScenes.first as? UIWindowScene else {
            return true
        }

        let productsListModuleFactory = ProductsListModuleFactory(productsURL: productsURL)

        let authViewController = AuthViewController()
        let authRouter = AuthRouterImpl(productsListModuleFactory: productsListModuleFactory)
        let loginUseCase = LocalLoginUseCase()
        let authPresenter = AuthPresenterImpl(
            view: authViewController,
            router: authRouter,
            loginUseCase: loginUseCase
        )

        authViewController.presenter = authPresenter
        authRouter.viewController = authViewController

        let navigationController = UINavigationController(rootViewController: authViewController)

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.window = window
        return true
    }
}
