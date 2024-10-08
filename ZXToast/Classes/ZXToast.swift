//
//  ZXTipView.swift
//  Agriculture_Saas
//
//  Created by zxcl on 2022/1/5.
//

import Foundation
import UIKit


/// activity 标记
let activityTimeFlag :TimeInterval = -1

public struct ZXToast{
    
    public static func showActivity(_ text: String="", isForce: Bool = false){
        var activity : UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            activity = UIActivityIndicatorView(style: .large)
        } else {
            activity = UIActivityIndicatorView(style: .whiteLarge)
        }
        activity.color = .white
        activity.startAnimating()
        show(activity, text: text, position: .center,delayHide: activityTimeFlag, isForce: isForce)
    }
    
    
    public static func showText(_ text: String,position: ToastPosition = .center){
        show(nil, text: text, position: position,delayHide: textShowTime(text: text))
    }
    
    
    public static func showSuccess(_ text: String=""){
        showImage(loadBundleImage("success"), text: text)

    }
    
    public static func showError(_ text: String=""){
        showImage(loadBundleImage("fail"), text: text)
    }
    
    public static func showImage(_ image: UIImage?,text: String, style: ToastStyle? = nil){
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        show(imageView, text: text, position: .center, delayHide: 1.5, style: style)
    }

    
    
    public static func show(_ customerView: UIView?=nil,text: String,position: ToastPosition,delayHide: TimeInterval, style: ToastStyle? = nil, isForce: Bool = false){
       guard (customerView != nil || !text.isEmpty) else {
           return
       }
       var config = ToasConfig(customerView: customerView, text: text, delay: delayHide, position: position)
       config.style = style ?? ToastStyle()
       config.isForce = isForce
       let toastView = ZXToastContentView(config: config)
       ToastManager.share.insert(toastView)
    }
    public static func hideActivity(force:Bool = false){
        ToastManager.share.activity?.hideActivity(force:force)
    }
    
    public static func hideToast(){
        ToastManager.share.toasts.forEach({$0.removeFromSuperview()})
        ToastManager.share.toasts = []
     }
    
    private static func textShowTime(text: String) -> TimeInterval{
        if text.count <= 10{
            return 1
        }else if text.count <= 20{
            return 2
        }else if text.count <= 40{
            return 2.5
        }else{
            return 3
        }
    }
    
}

func loadBundleImage(_ name: String) -> UIImage {
   let currentBundle = Bundle(for:ZXToastContentView.classForCoder())
    return UIImage(named: name, in: Bundle(path: currentBundle.path(forResource: "ZXToast", ofType: "bundle") ?? ""), compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) ?? UIImage()
}
