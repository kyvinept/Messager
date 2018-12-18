
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let applicationAssembly: ApplicationAssembly
    let applicationRouter: ApplicationRouter
    
    override init() {
        let applicationAssembly = ApplicationAssembly()
        let applicationRouter = ApplicationRouter(applicationAssembly: applicationAssembly)
        
        self.applicationAssembly = applicationAssembly
        self.applicationRouter = applicationRouter
        
        applicationAssembly.notificationManager.startNotifications()
    }

    private func setupWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        applicationRouter.showInitialUI(forWindow: self.window!)
        self.window!.makeKeyAndVisible()
        UIApplication.shared.statusBarStyle = .default
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //applicationAssembly.notificationManager.register(deviceForRemoteNotification: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        applicationAssembly.notificationManager.errorRegisterDevice()
    }
}

