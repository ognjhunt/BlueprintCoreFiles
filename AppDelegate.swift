//
//  AppDelegate.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 9/11/22.
//

import UIKit
import ARKit
import Firebase
import CoreData
import FirebaseAuth
import FirebaseFirestore
import FirebaseInstallations
//import GoogleMaps
//import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var user: User!
    
   // let instanceID = InstanceID.instanceID()
    
    override init() {
            FirebaseApp.configure()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      

        let db = Firestore.firestore()
        let defaults = UserDefaults.standard
//        GMSServices.provideAPIKey("AIzaSyBgxzzgcT_9nyhz1D_JtfG7gevRUKQ5Vbs")
//        GMSPlacesClient.provideAPIKey("AIzaSyBgxzzgcT_9nyhz1D_JtfG7gevRUKQ5Vbs")
       // if Auth.auth().currentUser != nil {
        if defaults.bool(forKey: "finishedPermissions") == true {

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
       //     let initialViewController = storyboard.instantiateViewController(withIdentifier: "LaunchVC")
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "BlueprintVC")

         //   let initialViewController = storyboard.instantiateViewController(withIdentifier: "SearchVC")

              self.window?.rootViewController = initialViewController
        } else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LaunchVC")
            let storyboard = UIStoryboard(name: "Walkthrough", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "InitialVC")
            self.window?.rootViewController = initialViewController
        }
        
        IAPManager.shared.fetchProducts()
//        // Register for push notifications
//           UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
//               if granted {
//                   DispatchQueue.main.async {
//                       application.registerForRemoteNotifications()
//                   }
//               }
//           }
      return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
//        // Check for token change
//        FirebaseInstallation.getInstance().getId() { (result, error) in
//               if let error = error {
//                   print("Error fetching token: \(error.localizedDescription)")
//               } else if let result = result {
//                   if result != UserDefaults.standard.string(forKey: "device_token") {
//                       // Token has changed, update it on the server
//                       UserDefaults.standard.set(result, forKey: "device_token")
//                       let data = result.data(using: .utf8)
//                       self.saveDeviceToken(data!)
//                   }
//               }
//           }
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")

            guard granted else { return }
            self.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func saveDeviceToken(_ deviceToken: Data) {
        // Check if user is logged in
        if let user = Auth.auth().currentUser {
            // Save device token to user's document in Firestore
            let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02x", $1)})
            let userRef = Firestore.firestore().collection("users").document(user.uid)
            userRef.updateData(["deviceToken": deviceTokenString]) { (error) in
                if let error = error {
                    print("Error saving device token: \(error.localizedDescription)")
                } else {
                    print("Successfully saved device token for user \(user.uid)")
                }
            }
        } else {
            // Save device token to UserDefaults or Keychain
            let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02x", $1)})
            UserDefaults.standard.set(deviceTokenString, forKey: "device_token")
        }
    }

    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Handle error
        print("Failed to register for remote notifications with error: \(error)")
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("", {$0 + String(format: "%02x", $1)})
        print("Device Token: \(token)")
        if let user = Auth.auth().currentUser {
            // Convert token to Data
            let deviceTokenData = token.data(using: .utf8)
            // Save the device token to the user's profile in your database
            saveDeviceToken(deviceTokenData!)
        } else {
            // Save the device token to local storage or in memory
            UserDefaults.standard.set(token, forKey: "device_token")
        }
    }


}

