//
//  HUD.swift
//  SwiftHUD
//
//  Created by jianwen ning on 2019/11/18.
//  Copyright © 2019 jianwen ning. All rights reserved.
//
//  通用的hud，用于操作提示，网络请求提示。提供显示 错误❎信息，警告⚠️信息，成功信息；网络请求的loading，toast提示，长文本提示。

import Foundation
import MBProgressHUD

final class HUD {

    enum HUDStyle: Int {
        case solidColor = 0 //单色
        case blur = 1 // 毛玻璃效果
    }
    
    typealias Complection = (() -> Void)
    static var defaultDelay: TimeInterval = 2 // 默认两秒
    static var globalHud: MBProgressHUD? // 接收hud，方便隐藏做隐藏操作
    static var defaultHudStyle: HUDStyle = .solidColor
    
    /// 设置hud的样式(不设置就使用默认的2秒和单色背景)
    /// - Parameters:
    ///   - showTime: hud显示时长
    ///   - hudStyle: hud样式
    static func globalStyle(showTime: TimeInterval, hudStyle: HUDStyle) {
        defaultDelay = showTime
        defaultHudStyle = hudStyle
    }
    /// 显示信息的基础方法
    /// - Parameters:
    ///   - message: 消息
    ///   - iconName: 图标明
    ///   - targetView: 目标视图
    ///   - delay: 显示时间
    private static func show(message: String, iconName: String, targetView: UIView? = nil, delay: TimeInterval, completion: Complection? = nil) {
        if message.count == 0 {
            return
        }
        var target: UIView
        if targetView != nil {
            target = targetView!
        }else {
            target = UIApplication.shared.keyWindow ?? UIView()
        }
        let hud = MBProgressHUD.showAdded(to: target, animated: true)
        hud.bezelView.layer.cornerRadius = 4.0
        hud.bezelView.style = MBProgressHUDBackgroundStyle(rawValue: defaultHudStyle.rawValue)! //.solidColor // 单色背景
        hud.label.text = message
        
        var image: UIImage?
        switch defaultHudStyle {
        case .solidColor:
            image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
        default:
            image = UIImage(named: iconName)?.withRenderingMode(.alwaysOriginal)
        }
        hud.customView = UIImageView(image: image)
        hud.mode = .customView
        hud.removeFromSuperViewOnHide = true
        DispatchQueue.main.async {
            hud.hide(animated: true, afterDelay: delay)
        }
        if completion != nil {
            completion!()
        }
    }

    /// 显示成功的提示信息
    /// - Parameters:
    ///   - message: 信息
    ///   - targetView: 目标视图
    ///   - delay: 显示时间，默认2秒
    static func showSuccess(message: String, targetView: UIView? = nil, delay: TimeInterval = defaultDelay, completion: Complection? = nil) {
        show(message: message, iconName: "success", targetView: targetView, delay: delay, completion: completion)
    }

    /// 显示错误的提示信息
    /// - Parameters:
    ///   - message: 信息
    ///   - targetView: 目标视图
    ///   - delay: 显示时间，默认2秒
    static func showError(message: String, targetView: UIView? = nil, delay: TimeInterval = defaultDelay, completion: Complection? = nil) {
        show(message: message, iconName: "error", targetView: targetView, delay: delay, completion: completion)
    }


    /// 显示警告的提示信息
    /// - Parameters:
    ///   - message: 信息
    ///   - targetView: 目标视图
    ///   - delay: 显示时间，默认2秒
    static func showWaring(message: String, targetView: UIView? = nil, delay: TimeInterval = defaultDelay, completion: Complection? = nil) {
        show(message: message, iconName: "warning", targetView: targetView, delay: delay, completion: completion)
    }

    /// 显示网络请求的loading，需要在请求成功之后隐藏loading
    /// - Parameters:
    ///   - message: 提示消息
    ///   - targetView: 目标视图
    static func showLoading(message: String, targetView: UIView?) {
        var target: UIView
        if targetView != nil {
            target = targetView!
        }else {
            target = UIApplication.shared.keyWindow ?? UIView()
        }
        //在显示新的之前需要隐藏掉旧的，否则会导致多个loading页面重叠
        MBProgressHUD.hide(for: target, animated: true)
        let hud = MBProgressHUD.showAdded(to: target, animated: true)
        hud.bezelView.layer.cornerRadius = 4.0
        hud.label.text = message.count > 0 ? message : "loading ..."
        hud.bezelView.style = MBProgressHUDBackgroundStyle(rawValue: defaultHudStyle.rawValue)!//.solidColor // 单色背景
        hud.removeFromSuperViewOnHide = true
        globalHud = hud
    }

    /// 显示长文本消息
    /// - Parameters:
    ///   - message: 消息
    ///   - targetView: 目标视图
    static func showLongMessage(message: String, targetView: UIView? = nil, delay: TimeInterval = defaultDelay) {
        if message.count == 0 {
            return
        }
        var target: UIView
        if targetView != nil {
            target = targetView!
        }else {
            target = UIApplication.shared.keyWindow ?? UIView()
        }
        let hud = MBProgressHUD.showAdded(to: target, animated: true)
        hud.bezelView.layer.cornerRadius = 4.0
        hud.bezelView.style = MBProgressHUDBackgroundStyle(rawValue: defaultHudStyle.rawValue)! //.solidColor // 单色背景
        hud.detailsLabel.text = message
        hud.mode = .text
        hud.removeFromSuperViewOnHide = true
        DispatchQueue.main.async {
            hud.hide(animated: true, afterDelay: delay)
        }
    }
    
    /// 显示标题和副标题
    /// - Parameters:
    ///   - title: 标题
    ///   - subTitle: 副标题
    ///   - targetView: 目标视图
    static func show(title: String, subTitle: String, targetView: UIView? = nil, delay: TimeInterval = defaultDelay) {
        if title.count == 0 && subTitle.count == 0 {
            return
        }
        var target: UIView
        if targetView != nil {
            target = targetView!
        }else {
            target = UIApplication.shared.keyWindow ?? UIView()
        }
        let hud = MBProgressHUD.showAdded(to: target, animated: true)
        hud.bezelView.layer.cornerRadius = 4.0
        hud.bezelView.style = MBProgressHUDBackgroundStyle(rawValue: defaultHudStyle.rawValue)! //.solidColor // 单色背景
        hud.label.text = title
        hud.detailsLabel.text = subTitle
        hud.mode = .text
        hud.removeFromSuperViewOnHide = true
        DispatchQueue.main.async {
            hud.hide(animated: true, afterDelay: delay)
        }
    }

    /// 隐藏HUD
    static func hide() {
        DispatchQueue.main.async {
            globalHud?.hide(animated: true)
        }
    }

    /// 隐藏HUD，带回调
    /// - Parameters:
    ///   - complection: 回调
    static func hide(complection: ((Bool) -> Void)? = nil) {
        DispatchQueue.main.async {
            globalHud?.hide(animated: true)
        }
        globalHud?.completionBlock = {
            if complection != nil {
                complection!(true)
            }
        }
    }

    /// 隐藏HUD，带延时
    /// - Parameters:
    ///   - delay: 延时
    ///   - complection: 回调
    static func hide(delay: TimeInterval) {
        DispatchQueue.main.async {
            globalHud?.hide(animated: true, afterDelay: delay)
        }
    }
}
