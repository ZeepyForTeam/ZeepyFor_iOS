//
//  AppDelegate.swift
//  Zeepy
//
//  Created by 김태훈 on 2021/03/06.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import KakaoSDKCommon 
import RxKakaoSDKCommon
import RxKakaoSDKAuth
import KakaoSDKAuth
import AuthenticationServices
import NaverThirdPartyLogin
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    RxKakaoSDKCommon.initSDK(appKey: "02c78bdac1dc2a54c54f8e7ba13183d2")
    let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    instance?.isNaverAppOauthEnable = true
    instance?.isOnlyPortraitSupportedInIphone()
    instance?.serviceUrlScheme = kServiceAppUrlScheme
    instance?.consumerKey = kConsumerKey
    instance?.consumerSecret = kConsumerSecret
    instance?.appName = kServiceAppName
    #if RELEASE
    print("릴ㄹ리즈 버전")
    #endif
    NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil, queue: nil) { (Notification) in
      print("Revoked Notification")
      LoginManager.shared.makeLogoutStatus()
      // 로그인 페이지로 이동
    }

    if #available(iOS 10.0, *) {
      // For iOS 10 display notification (sent via APNS)
      UNUserNotificationCenter.current().delegate = self
      
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    window?.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
    
    let rootNav = UINavigationController()
    rootNav.navigationBar.isHidden = true
    let rootVC = TabbarViewContorller()
    print(UserDefaultHandler.loginType)
    print(UserDefaultHandler.userId)
    rootNav.viewControllers = [rootVC]
    if LoginManager.shared.isLogin() == true {
      UserManager.shared.fetchUserAddress()
      window?.rootViewController = rootNav
      window?.makeKeyAndVisible()
    }
    else {
//      rootNav.viewControllers = [LoginEmailViewController()]
      rootNav.viewControllers = [OnboardingViewController()]
      window?.rootViewController = rootNav
      window?.makeKeyAndVisible()
    }
    return true
  }
  // MARK: - Core Data stack
  
  lazy var persistentContainer: NSPersistentCloudKitContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentCloudKitContainer(name: "Zeepy")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  

  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
}
extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    Messaging.messaging().appDidReceiveMessage(notification.request.content.userInfo) // userinfo를 didReceiveMessage로 보내서 처리하는건지?
    completionHandler([.alert, .sound, .badge])
  }
}
extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
    
    let dataDict:[String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }
}
extension AppDelegate {
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if (AuthApi.isKakaoTalkLoginUrl(url)) {
      return AuthController.rx.handleOpenUrl(url: url)
    }
    NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)

    return false
  }
}
