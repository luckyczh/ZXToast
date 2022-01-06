//
//  ZXTipView.swift
//  Agriculture_Saas
//
//  Created by zxcl on 2022/1/5.
//

import Foundation
import UIKit




public struct ZXToast{
    
    public static func showActivity(_ text:String=""){
        DispatchQueue.main.async {
            var activity : UIActivityIndicatorView!
            if #available(iOS 13.0, *) {
                activity = UIActivityIndicatorView(style: .large)
            } else {
                activity = UIActivityIndicatorView(style: .whiteLarge)
            }
            activity.color = .white
            activity.startAnimating()
            show(activity, text: text, position: .center,delayHide: ToastManager.share.activityTimeFlag)
        }
    }
    
    
    public static func showText(_ text:String,position:ZXToastContentView.ToastPosition = .center){
        show(nil, text: text, position: position,delayHide: textShowTime(text: text))
    }
    
    
    public static func showSuccess(_ text:String=""){
        showImage("success", text: text)
    }
    
    public static func showError(_ text:String=""){
        showImage("fail", text: text)
    }
    
    private static func showImage(_ image:String,text:String){
        DispatchQueue.main.async {
            let imageView = UIImageView(image: loadBundleImage(image, bundleClass: ZXToastContentView.self))
            imageView.contentMode = .scaleAspectFit
            imageView.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
            show(imageView, text: text, position: .center, delayHide: 1.5)
        }
    }

    
    
   private static func show(_ customerView:UIView?=nil,text:String,position:ZXToastContentView.ToastPosition,delayHide:TimeInterval){
       guard (customerView != nil || !text.isEmpty) else {
           return
       }
        DispatchQueue.main.async {
            let config = ToasConfig(customerView: customerView, text: text, delay: delayHide, position: position)
            let vi = ZXToastContentView(config: config)
            vi.insertToast()
        }

    }
   public static func hideActivity(){
        DispatchQueue.main.async {
             while !ToastManager.share.activities.isEmpty{
                 UIView.animate(withDuration: ToastManager.share.fadeTime) {
                     ToastManager.share.activities.last?.alpha = 0
                 } completion: { _ in
                     ToastManager.share.activities.last?.removeFromSuperview()
                     ToastManager.share.activities.removeAll(where: {$0===ToastManager.share.activities.last!})
                 }
             }
        }
    }
    
    private static func textShowTime(text:String) -> TimeInterval{
        if text.count <= 20{
            return 1
        }else if text.count <= 40{
            return 2
        }else if text.count <= 50{
            return 2.5
        }else{
            return 3
        }
    }
    
}

func loadBundleImage(_ name:String,type:String = ".png",bundleClass:AnyClass) -> UIImage?{
   let currentBundle = Bundle(for:bundleClass)
   let imagePath = currentBundle.path(forResource: name + type, ofType: nil, inDirectory: "ZXToast" + ".bundle")
   return UIImage(contentsOfFile: imagePath ?? "")?.withRenderingMode(.alwaysOriginal)
}
