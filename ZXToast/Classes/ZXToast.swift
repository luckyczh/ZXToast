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
    
    public static func showActivity(_ text: String=""){
        var activity : UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            activity = UIActivityIndicatorView(style: .large)
        } else {
            activity = UIActivityIndicatorView(style: .whiteLarge)
        }
        activity.color = .white
        activity.startAnimating()
        show(activity, text: text, position: .center,delayHide: activityTimeFlag)
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
    
    public static func showImage(_ image: UIImage,text: String){
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        show(imageView, text: text, position: .center, delayHide: 1.5)
    }

    
    
   public static func show(_ customerView: UIView?=nil,text: String,position: ToastPosition,delayHide: TimeInterval){
       guard (customerView != nil || !text.isEmpty) else {
           return
       }            
       let config = ToasConfig(customerView: customerView, text: text, delay: delayHide, position: position)
       
//       guard !ToastManager.share.enableQueue else {
           let toastView = ZXToastContentView(config: config)
           ToastManager.share.insert(toastView)
//           return
//       }
//       
//       if let toastView = ToastManager.share.toasts.first{
//           toastView.updateConfig(config)
//       }else {
//           let toastView = ZXToastContentView(config: config)
//           ToastManager.share.insert(toastView)
//       }
            

    }
   public static func hideActivity(){
       ToastManager.share.activity?.hideActivity()
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
