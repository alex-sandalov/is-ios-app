import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let productsURL = URL(
        string: "https://alfaitmo.ru/server/echo/409515%2Fbank%2Fproducts"
    )!

    private let remoteBDUIBaseURL = URL(
        string: "https://alfaitmo.ru/server/echo"
    )!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        guard let windowScene = application.connectedScenes.first as? UIWindowScene else {
            return true
        }

        let remoteBDUIScreenModuleFactory = RemoteBDUIScreenModuleFactory()

        let remoteBDUIEndpointFactory = RemoteBDUIEndpointFactory(
            baseURL: remoteBDUIBaseURL,
            namespace: "beta-bank"
        )

        let productsListModuleFactory = ProductsListModuleFactory(
            productsURL: productsURL,
            remoteBDUIScreenModuleFactory: remoteBDUIScreenModuleFactory,
            remoteBDUIEndpointFactory: remoteBDUIEndpointFactory
        )

        let authViewController = AuthViewController()

        let authRouter = AuthRouterImpl(
            productsListModuleFactory: productsListModuleFactory
        )

        let loginUseCase = LocalLoginUseCase()

        let authPresenter = AuthPresenterImpl(
            view: authViewController,
            router: authRouter,
            loginUseCase: loginUseCase
        )

        authViewController.presenter = authPresenter
        authRouter.viewController = authViewController

        let navigationController = UINavigationController(
            rootViewController: authViewController
        )

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.window = window

        return true
    }
}
