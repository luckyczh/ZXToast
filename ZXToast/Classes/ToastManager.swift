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

public struct ToastStyle {
    
    
    public var contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    public var backgroundColor: UIColor = .black
    public var cornerRadius: CGFloat = 5
    public var textColor: UIColor = .white
    public var textFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    public init() {}
    
    public init(contentInset: UIEdgeInsets, backgroundColor: UIColor, cornerRadius: CGFloat, textColor: UIColor, textFont: UIFont) {
        self.contentInset = contentInset
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.textColor = textColor
        self.textFont = textFont
    }
}

struct ToasConfig {
    var customerView : UIView?
    var text = ""
    var delay : TimeInterval = 0
    var position = ToastPosition.center
    var style = ToastStyle()
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
            if ToastManager.share.activity != nil {
                ToastManager.share.activity?.hideActivity()
            }
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
