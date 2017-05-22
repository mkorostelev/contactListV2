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
        
        let st = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        
        let nc = st.instantiateInitialViewController() as? UINavigationController
        
        if var vc = nc?.viewControllers.first as? ContactsListProtocol {
            vc.contactList = ContactsList()
        }
        
        self.window = UIWindow()
        
        self.window?.rootViewController = nc
        
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

