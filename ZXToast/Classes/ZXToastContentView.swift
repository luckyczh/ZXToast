//
//  ToastContentView.swift
//  
//
//  Created by zxcl on 2022/1/4.
//

import UIKit

extension UIEdgeInsets{
    
    public var horizontalValue :CGFloat{
        return left + right
    }
    
    public var verticalValue :CGFloat{
        return top + bottom
    }
    
    init(only top: CGFloat=0, left: CGFloat=0, bottom: CGFloat=0, right: CGFloat=0) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
    
    init(all: CGFloat=0) {
        self.init(top: all, left: all, bottom: all, right: all)
    }
    
}

extension UIWindow{
    public var zx_safeAreaInsets: UIEdgeInsets{
        if #available(iOS 11, *){
            return safeAreaInsets
        }
        return .zero
    }
}



public class ZXToastContentView: UIView {
    
    private var inset: UIEdgeInsets = .zero
    private var customerView : UIView?
    private var config = ToasConfig()
    
    var isActivity = false
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 15)
        lab.textColor = .white
        lab.textAlignment = .center
        lab.numberOfLines = 0
        return lab
    }()
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(loadBundleImage("close"), for: .normal)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(closeActivity), for: .touchUpInside)
        addSubview(btn)
        return btn
    }()
    
    init(config:ToasConfig) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.8, height: 0))
        layer.cornerRadius = 5
        backgroundColor = .black
        autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        addSubview(titleLabel)
        titleLabel.text = config.text
        inset = config.contentInset
        customerView = config.customerView
        isActivity = config.delay == ToastManager.share.activityTimeFlag
        self.config = config
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let vi = super.hitTest(point, with: event)
        if vi is Self{
            return nil
        }
        return vi
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let hasCustomView = customerView != nil
        let hasTitle = !config.text.isEmpty
        if hasCustomView{
            if isActivity{
                customerView!.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            }
            customerView!.frame.origin.y = inset.top
            addSubview(customerView!)
        }
        
        let tx = NSString(string: config.text)
        let txSize = tx.boundingRect(with: CGSize(width: bounds.width - inset.left - inset.right, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading,.usesLineFragmentOrigin], attributes: [.font:titleLabel.font as Any], context: nil).size
        /// 计算内容大小
        var contentWidth :CGFloat = txSize.width
        var contentHeight :CGFloat = txSize.height
        if hasCustomView{
            if customerView is UIActivityIndicatorView{
                contentWidth = max(max(customerView!.bounds.width, txSize.width), ToastManager.share.activityMinWidth)
                contentHeight = max(customerView!.bounds.height + txSize.height + itemMargin(), ToastManager.share.activityMinHeight)
            }else{
                contentHeight = customerView!.bounds.height + txSize.height + itemMargin()
                contentWidth = max(max(customerView!.bounds.width, txSize.width), contentHeight)
            }
        }
        bounds = CGRect(origin: .zero, size: CGSize(width: contentWidth + inset.horizontalValue, height: contentHeight + inset.verticalValue))
        
        
        /// 重新设置子视图位置
        if hasCustomView{
            customerView?.center.x = bounds.midX
            closeBtn.frame = CGRect(x: bounds.width - 30, y: 0, width: 30, height: 30)
            addSubview(closeBtn)
            if !hasTitle{
                customerView?.center.y = bounds.midY
            }else{
                customerView?.frame.origin.y = (bounds.height - (customerView!.bounds.height + txSize.height + itemMargin()))/2.0
                titleLabel.frame = CGRect(x: inset.left, y: customerView!.frame.maxY + itemMargin(), width: bounds.width - inset.horizontalValue, height: txSize.height)
            }
        }else {
            titleLabel.frame = CGRect(x: inset.left, y: inset.top, width: bounds.width - inset.horizontalValue, height: txSize.height)
        }
        
    }
    
    @objc func closeActivity(){
        UIView.animate(withDuration: ToastManager.share.fadeTime) {
            ToastManager.share.activities.first?.alpha = 0
        } completion: { _ in
            ToastManager.share.activities.first?.removeFromSuperview()
            ToastManager.share.activities.removeFirst()
        }
    }
    
    func insertToast(){
        let window = UIApplication.shared.keyWindow!
        layoutIfNeeded()
        switch config.position {
        case .top:
            center.x = window.center.x
            frame.origin.y = window.zx_safeAreaInsets.top + 20
        case .center:
            center = window.center
        case .bottom:
            center.x = window.center.x
            frame.origin.y = window.bounds.height - bounds.height - window.zx_safeAreaInsets.bottom - 20
        }
        if isActivity{
            let warpperView = UIView(frame: UIScreen.main.bounds)
            warpperView.backgroundColor = .clear
            warpperView.addSubview(self)
            warpperView.alpha = 0
            center = warpperView.center
            ToastManager.share.activities.append(warpperView)
            showActivity()
        }else{
            alpha = 0
            ToastManager.share.toasts.append(self)
            if ToastManager.share.toasts.count <= 1{
                showToast()
            }
        }
        
    }
    

    func showToast(){
        let window = UIApplication.shared.keyWindow!
        objc_sync_enter(self)
        if let toast = ToastManager.share.toasts.first{
            window.addSubview(toast)
            let timer = Timer.init(timeInterval: config.delay, target: self, selector: #selector(hide(timer:)), userInfo: ["toast":toast], repeats: false)
            RunLoop.current.add(timer, forMode: .common)
            UIView.animate(withDuration: ToastManager.share.fadeTime) {
                toast.alpha = 1
            }
        }
        objc_sync_exit(self)
    }
    
    func showActivity(){
        let window = UIApplication.shared.keyWindow!
        objc_sync_enter(self)
        if let activity = ToastManager.share.activities.last{
            window.addSubview(activity)
            let timer = Timer.init(timeInterval: ToastManager.share.activityTime, target: self, selector: #selector(showCloseBtn(timer:)), userInfo: nil, repeats: false)
            RunLoop.current.add(timer, forMode: .common)
            UIView.animate(withDuration: ToastManager.share.fadeTime) {
                activity.alpha = 1
            }
        }
        objc_sync_exit(self)
    }
    
    @objc func showCloseBtn(timer:Timer){
        closeBtn.isHidden = false
        timer.invalidate()
    }
    
    @objc func hide(timer:Timer){
        guard let userInfo = timer.userInfo as? [String:ZXToastContentView],let toast = userInfo["toast"] else{
            return
        }
        timer.invalidate()
        DispatchQueue.main.async {
            UIView.animate(withDuration: ToastManager.share.fadeTime) {
                toast.alpha = 0
            } completion: { _ in
                toast.removeFromSuperview()
                ToastManager.share.toasts.removeAll(where: {$0===toast})
                if !ToastManager.share.toasts.isEmpty{
                    toast.showToast()
                }
            }
        }
    }
    
    func itemMargin() -> CGFloat{
        return config.text.isEmpty ? 0 : 10
    }
    
    
    
    

}
