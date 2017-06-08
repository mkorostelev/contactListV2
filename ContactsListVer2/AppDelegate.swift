//
//  AppDelegate.swift
//  ContactsListVer2
//
//  Created by Maksym Korostelov on 5/17/17.
//  Copyright © 2017 Maksym Korostelov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        
        let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        
        if let viewController = navigationController?.viewControllers.first as? ContactsListTVC {
            let presenter = ContactListTVCPresenter(contactsListTVC: viewController, contactList: ContactsList())
            
            let router = ContactListTVCRouter(contactListTVCPresenter: presenter, navigationController: navigationController!)
            
            presenter.router = router
            
            viewController.presenter = presenter
        }
        
        self.window = UIWindow()
        
        self.window?.rootViewController = navigationController
        
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
