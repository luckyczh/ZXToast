//
//  ToastManager.swift
//  ZXToast
//
//  Created by Jemmy Chen on 2024/5/6.
//

import Foundation

public enum ToastType: Equatable {
    case text
    case iconText(icon: UIImage)
    case loading
    
    var equalValue: Int {
        switch self {
        case .text:
            0
        case .iconText:
            1
        case .loading:
            2
        }
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.equalValue == rhs.equalValue
    }
}

public enum ToastPosition {
    case top
    case center
    case bottom
}

public enum ToastAnimation {
    case fade
    case slide
    case scale
    case custom(show: (UIView, @escaping () -> Void) -> Void,
                hide: (UIView, @escaping () -> Void) -> Void)
}

public struct ToastConfig {
    public var type: ToastType = .text
    public var position: ToastPosition = .center
   
    public var backgroundColor: UIColor = UIColor.black
    public var textColor: UIColor = .white
    public var font: UIFont = .systemFont(ofSize: 15)
    public var cornerRadius: CGFloat = 12.0
    public var padding: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    public var maxWidth: CGFloat = UIScreen.main.bounds.width - 40
    public var imageSize: CGSize = CGSize(width: 30, height: 30)
    /// 当position为 top 和 bottom时生效
    public var verticalOffset: CGFloat = 40.0
    
    public var showAnimation: ToastAnimation = .scale
    public var hideAnimation: ToastAnimation = .fade
    
    public var blurEffect: UIBlurEffect.Style?
    public var shadow: (color: UIColor, radius: CGFloat, opacity: Float) = (.black, 8, 0.2)
    public var minDisplayDuration: TimeInterval = 1.0
    public var maxDisplayDuration: TimeInterval = 5.0
    public var charDurationRatio: TimeInterval = 0.06
    
    public var useQueue: Bool = true
    
    public static var `default` = ToastConfig()
}


public final class ToastManager {
    public static let shared = ToastManager()
    private var queue = [NEToast]()
    private init() {}
    
    private var currentToast: NEToast?
    private let lock = NSLock()
    
    public func show(_ toast: NEToast) {
        /// 当只显示文本时，文本为空不展示
        if toast.config.type == .text && toast.message?.isEmpty != false {
            return
        }
        executeLocked {
            if toast.config.useQueue {
                queue.append(toast)
                processNext()
            }else {
                showImmediately(toast)
            }
        }
    }
    
    private func showImmediately(_ toast: NEToast) {
        currentToast?.hide()
        currentToast = toast
        toast.show { [weak self] in
            self?.currentToast = nil
        }
    }
    
    private func processNext() {
        guard currentToast == nil, let next = queue.first else { return }
        queue.removeFirst()
        currentToast = next
        next.show { [weak self] in
            self?.executeLocked {
                self?.currentToast = nil
                self?.processNext()
            }
        }
    }
    
    public func hideAll() {
        executeLocked {
            queue.removeAll()
            currentToast?.hide()
            currentToast = nil
        }
    }
    
    private func executeLocked(_ block: () -> Void) {
        lock.lock()
        defer { lock.unlock() }
        block()
    }
}
