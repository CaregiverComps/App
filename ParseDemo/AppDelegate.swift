//
//  AppDelegate.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/28/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        AccessLevel.registerSubclass();
        AppUser.registerSubclass();
        Essentials.registerSubclass();
        NFObject.registerSubclass();
        Parse.enableLocalDatastore()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // Initialize Parse.
        Parse.setApplicationId("vSfFMOf1zACuT3bTD0anRgM3JGVoGZ0p2MQ0KwWg", clientKey: "h1XSnv5RTzVHHp3jOA15VE22IHZvobhrn0Evt9Ei")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 51.0/255, green: 153.0/255, blue: 204.0/255, alpha: 1.0)

//        UINavigationBar.appearance().backgroundColor = UIColor(red: 51.0/255, green: 153.0/255, blue: 204.0/255, alpha: 1.0)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

