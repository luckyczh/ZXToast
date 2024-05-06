//
//  ToastManager.swift
//  ZXToast
//
//  Created by Jemmy Chen on 2024/5/6.
//

import Foundation


public enum ToastPosition {
     case top
     case center
     case bottom
 }

struct ToasConfig {
    var contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var customerView : UIView?
    var text = ""
    var delay : TimeInterval = 0
    var position = ToastPosition.center
}

public struct ToastManager{
    
    public static var share = ToastManager()
    /// loading框关闭按钮出现延迟
    public var activityTime :TimeInterval = 8
    /// toast 出现动画时间
    public var fadeTime : TimeInterval = 0.2
    
    let activityMinWidth :CGFloat = 80
    let activityMinHeight :CGFloat = 80
    /// activity 标记
    let activityTimeFlag :TimeInterval = -1
    var toasts = [ZXToastContentView]()
    var activities = [UIView]()
    
    private init() {}
    
    
}
