//
//  AppDelegate.swift
//  Solity Demo
//
//  Created by Solity 013 on 2021/11/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, BMKGeneralDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //要使用百度地图，请先启动BMKMapManager
        let mapManager = BMKMapManager()
        //启动引擎并设置AK并设置delegate
        if !(mapManager.start(keyBaiduMap, generalDelegate: self)) {
            NSLog("启动引擎失败")
        }
        
        return true
    }

    // MARK: UserAction
    
    /**
     联网结果回调
     
     @param iError 联网结果错误码信息，0代表联网成功
     */
    func onGetNetworkState(_ iError: Int32) {
        if 0 == iError {
            NSLog("联网成功")
        } else {
            NSLog("联网失败：%d", iError)
        }
    }
    
    /**
     鉴权结果回调
     
     @param iError 鉴权结果错误码信息，0代表鉴权成功
     */
    func onGetPermissionState(_ iError: Int32) {
        if 0 == iError {
            NSLog("授权成功")
        } else {
            NSLog("授权失败：%d", iError)
        }
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

