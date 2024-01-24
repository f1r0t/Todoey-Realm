//
//  AppDelegate.swift
//  Todoey
//
//  Created by Fırat AKBULUT on 28.09.2023.
//

import UIKit

import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{
            _ = try Realm()
        }catch{
            print(error)
        }
        return true
    }
    
}



