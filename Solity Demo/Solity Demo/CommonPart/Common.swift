//
//  Common.swift
//  Solity Demo
//
//  Created by Solity 013 on 2021/11/25.
//

import UIKit
import Foundation

////com.SolityChina.BaiduMapDemo
//let keyBaiduMap: String = "tC1Db6Wv0IHxCdhDHRCaWlhNbCtb3DRa"
////cn.co.tal.smartdoorlock.smartsolity
//let keyBaiduMap: String = "z6g1HoTg6m9pp22UyGwUBgS2iifhib06"
//com.SolityChina.Demo
let keyBaiduMap: String = "YmkATvmP50IQv5quhU9ryUnu8vQFGxPz"


let widthScale: CGFloat = UIScreen.main.bounds.size.width/375
let heightScale: CGFloat = UIScreen.main.bounds.size.height/667

let KScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let KScreenHeight: CGFloat = UIScreen.main.bounds.size.height

let KStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
let KNavigationBarHeight: CGFloat = 44
let kViewTopHeight = KStatusBarHeight + CGFloat(KNavigationBarHeight)

let KiPhoneXSafeAreaDValue: CGFloat = UIApplication.shared.statusBarFrame.size.height > 20 ? 34.0 : 0.0

func COLOR(_ rgbValue: UInt) -> UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255.0
    let blue = CGFloat(rgbValue & 0xFF) / 255.0
    return UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
}
