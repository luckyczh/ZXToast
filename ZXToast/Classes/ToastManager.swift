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
    
    /// loading是否显示关闭按钮
    public var enbaleActivityClose = false
    /// loading框关闭按钮出现延迟
    public var activityTime :TimeInterval = 8
    /// toast 出现动画时间
    public var fadeTime : TimeInterval = 0.2
    /// toast 最小宽高
    public var toastMinWidth :CGFloat = 80
    public var toastMinHeight :CGFloat = 80
    /// 是否开启队列显示
    public var enableQueue = false
    
    var toasts = [ZXToastContentView]()
    var activity: ZXToastContentView?
    
    private init() {}

    func insert(_ toast:ZXToastContentView){
        guard !toast.isActivity else {
            ToastManager.share.activity = toast
            toast.showActivity()
            return
        }
        if ToastManager.share.enableQueue {
            ToastManager.share.toasts.append(toast)
            if ToastManager.share.toasts.count <= 1{
                toast.showText()
            }
        }else {
            ToastManager.share.toasts.forEach({$0.removeFromSuperview()})
            ToastManager.share.toasts = [toast]
            toast.showText()
        }
    }
}
