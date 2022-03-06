//
//  AppDelegate.swift
//  PolestarDemo
//
//  Created by Ajay Awasthi on 04/03/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setupDatabase()
        return true
    }
    
    // Creating database
    func setupDatabase(){
        let dbFolderPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0].appending("/Database")
        let dbPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0].appending("/Database/Book.db")
        let fileManager = FileManager.default
        let fileExist = fileManager.fileExists(atPath: dbPath)
        UserDefaults.standard.set(false, forKey: "FirstEntry")
        if fileExist == false {
            try? fileManager.createDirectory(atPath: dbFolderPath, withIntermediateDirectories: false, attributes: nil)
            try? fileManager.copyItem(atPath: Bundle.main.path(forResource: "Book", ofType: "db", inDirectory: nil)!, toPath: dbPath)
            UserDefaults.standard.set(true, forKey: "FirstEntry")

        }
        UserDefaults.standard.synchronize()
        print(dbPath)
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

